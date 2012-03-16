#!/usr/bin/env python
#
# Copyright 2007 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
from google.appengine.ext import webapp
from google.appengine.ext.webapp import util
from google.appengine.ext import db
from google.appengine.api import urlfetch

import jinja2
import webapp2
import logging
import json
import datetime
import sys
import calendar
import os
import re

CLASS_TYPE_STR = '__class'
CLASS_VALUE_STR = 'value'
ID_STR = '__id'

jinja_environment = jinja2.Environment(
    loader=jinja2.FileSystemLoader(os.path.dirname(__file__)))

def hook(dct):
    clsType = dct[CLASS_TYPE_STR]
    if clsType == 'date':
        return datetime.date.fromtimestamp(dct[CLASS_VALUE_STR])
    if clsType == 'email':
        return db.Email(dct[CLASS_VALUE_STR])
    if clsType == 'phone':
        return db.PhoneNumber(dct[CLASS_VALUE_STR])
    elif clsType == 'rating':
        return db.Rating(dct[CLASS_VALUE_STR])
     # The constructor can't handle the clsType tag, so delete it!
    dictCopy = dict((key,value) for key,value in dct.iteritems() if not key.startswith('__'))
    return globals()[clsType](**dictCopy).put()

class DataEncoder(json.JSONEncoder):
    def default(self, obj):
        logging.getLogger('encoder').info('Encoding: ' + obj.__class__.__name__)
        if isinstance(obj, datetime.datetime):
            return obj.strftime('%Y/%m/%d')
        elif isinstance(obj,db.Model):
            dictCopy = obj._entity
            dictCopy[CLASS_TYPE_STR] = obj.kind()
            dictCopy[ID_STR] = obj.key().id()
            return dictCopy
        elif isinstance(obj,db.GeoPt):
            return {CLASS_TYPE_STR: 'Location', 'latitude':obj.lat, 'longitude':obj.lon}
        elif isinstance(obj,db.Key):
            dictCopy = {}
            if obj.kind()!='Winery':
                dictCopy = db.get(obj)._entity
            dictCopy[CLASS_TYPE_STR] = obj.kind()
            dictCopy[ID_STR] = obj.id()
            return dictCopy

class Hours(db.Model):
    """Models the hours of operation"""
    openTime = db.StringProperty()
    closeTime = db.StringProperty()    

class WeeklyHours(db.Model):
    """Models the hours of operation"""
    monday = db.ReferenceProperty(Hours, collection_name="monday")
    tuesday = db.ReferenceProperty(Hours, collection_name="tuesday")
    wednesday = db.ReferenceProperty(Hours, collection_name="wednesday")
    thursday = db.ReferenceProperty(Hours, collection_name="thursday")
    friday = db.ReferenceProperty(Hours, collection_name="friday")
    saturday = db.ReferenceProperty(Hours, collection_name="saturday")
    sunday = db.ReferenceProperty(Hours, collection_name="sunday")

class Winery(db.Model):
    """Models a winery"""
    name = db.StringProperty()
    description = db.TextProperty()
    rating = db.RatingProperty()
    email = db.EmailProperty()
    phone = db.PhoneNumberProperty()
    hours = db.ReferenceProperty(WeeklyHours)
    address = db.PostalAddressProperty()
    location = db.GeoPtProperty()
    image = db.BlobProperty()
    
class Event(db.Model):
    """Models an event"""
    name = db.StringProperty()
    description = db.TextProperty()
    startDate = db.DateTimeProperty()
    startTime = db.StringProperty()
    endDate = db.DateTimeProperty()
    endTime = db.StringProperty()
    winery = db.ReferenceProperty(Winery)

class RestServer(webapp.RequestHandler):
    '''
    This class provides a RESTful API that we can use to
    add new tags to as well as view relevant data.
    '''
    
    log = logging.getLogger('API')

    def post(self):
        #Load the JSON values that were sent to the server
        newKey = json.loads(self.request.body, object_hook=hook)
        self.log.info("imported: " + str(dir(newKey)))

        #Returns the ID that was created
        self.response.write(str(newKey.id()))
    
    def get(self):
        #pop off the script name ('/api')
        self.request.path_info_pop()

        #forget about the leading '/' and seperate the Data type and the ID
        split = self.request.path_info[1:].split('/')
        self.log.info('after split:' + str(split))
        #If no ID, then we will return all objects of this type
        if len(split) == 1:
            everyItem = []
            #Finds the class that was specified from our list of global objects
            #and create a Query for all of these objects. Then iterate through
            #and collect the IDs
            for item in globals()[split[0]].all():
                everyItem.append(item)
            #Write JSON back to the client
            self.response.write(json.dumps(everyItem, cls=DataEncoder))
        else:
            #Convert the ID to an int, create a key and retrieve the object
            retrievedEntity = db.get(db.Key.from_path(split[0], int(split[1])))

            #Return the values in the entity dictionary
            self.response.write(DataEncoder().encode(retrievedEntity))
    
    def delete(self):
        #pop off the script name
        self.request.path_info_pop()

        #forget about the leading '/'
        split = self.request.path_info[1:].split(':')
        if len(split) == 1:
            for key in globals()[split[0]].all(keys_only=True):
                db.delete(key)
        else:
            db.delete(db.Key.from_path(split[0], int(split[1])))

class View(webapp.RequestHandler):
    log = logging.getLogger('view')

    def get(self):
        template_values = {'wineries':[winery.key().id()  for winery in Winery.all()],'events':[event.key().id() for event in Event.all()]}
        template = jinja_environment.get_template('index.html')
        self.response.out.write(template.render(template_values))
    
    def toTime(self, string):
        result = string.split('-')
        if len(result) != 2:
            return None;
        oTime = result[0].strip()
        cTime = result[1].strip()

        return Hours(openTime=oTime,closeTime=cTime).put()

    def post(self):
        self.log.info(self.request.POST)
        if self.request.get('winery_submit'):
            m = self.toTime(self.request.get('monday'))
            t = self.toTime(self.request.get('tuesday'))
            w = self.toTime(self.request.get('wednesday'))
            th = self.toTime(self.request.get('thursday'))
            f = self.toTime(self.request.get('friday'))
            s = self.toTime(self.request.get('saturday'))
            su = self.toTime(self.request.get('sunday'))
            h = WeeklyHours(monday=m,tuesday=t,wednesday=w,thursday=th,friday=f,saturday=s,sunday=su).put()
            
            lat_long = self.request.get('location').split(',')
            loc = db.GeoPt(float(lat_long[0].strip()), float(lat_long[1].strip()))
            
            blb = db.Blob(self.request.get('picture').encode('base64'))

            Winery(name=self.request.get('name'), description=self.request.get('description'), email=self.request.get('email'), phone=self.request.get('phone'), location=loc,hours=h, image=blb, address=db.PostalAddress(self.request.get('address')), rating=db.Rating(int(self.request.get('rating')))).put()
        else:
            wineryKey = db.Key.from_path('Winery',int(self.request.get("winery_id")))
            sdate = datetime.datetime.strptime(self.request.get("start_date"), '%Y/%m/%d')
            edate = datetime.datetime.strptime(self.request.get("end_date"), '%Y/%m/%d')
            Event(name=self.request.get("name"),description=self.request.get("description"),winery=wineryKey,startDate=sdate,startTime=self.request.get("start_time").strip(),endDate=edate,endTime=self.request.get("end_time").strip()).put()
        self.redirect('/')

app = webapp2.WSGIApplication([('/curlme', CurlMe),('/api.*', RestServer), ('.*',View)],
                                         debug=True)
