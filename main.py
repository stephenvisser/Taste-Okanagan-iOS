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

CLASS_TYPE_STR = '__class'
CLASS_VALUE_STR = 'value'

def hook(dct):
    clsType = dct[CLASS_TYPE_STR]
    if clsType == 'date':
        return datetime.date.fromtimestamp(dct[CLASS_VALUE_STR])
    if clsType == 'time':
        return datetime.time.fromtimestamp(dct[CLASS_VALUE_STR])
    if clsType == 'email':
        return db.Email(dct[CLASS_VALUE_STR])
    if clsType == 'phone':
        return db.PhoneNumber(dct[CLASS_VALUE_STR])
    elif clsType == 'rating':
        return db.Rating(dct[CLASS_VALUE_STR])
    elif clsType == 'custom':
        # The constructor can't handle the clsType tag, so delete it!
        dictCopy = dict((key,value) for key,value in dct.iteritems() if not key.startswith('__'))
        return Data(**dictCopy)
    return json.JSONDecoder.object_hook(dct)
    
class DataEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, datetime.date):
            return {CLASS_TYPE_STR: 'date', CLASS_VALUE_STR:calendar.timegm(obj.timetuple())}
        elif isinstance(obj, datetime.time):
            return {CLASS_TYPE_STR: 'time', CLASS_VALUE_STR:calendar.timegm(obj.timetuple())}
        elif isinstance(obj, datetime.date):
            return {CLASS_TYPE_STR: 'date', CLASS_VALUE_STR:calendar.timegm(obj.timetuple())}
        elif isinstance(obj,datetime.datetime):
            return {CLASS_TYPE_STR: 'timestamp', 'value':calendar.timegm(obj.utctimetuple())}
        elif isinstance(obj,Data):
            dictCopy = obj._entity
            dictCopy[CLASS_TYPE_STR] = 'data'
            return dictCopy
        return json.JSONEncoder.default(self, obj)

class WeeklyHours(db.Model):
    """Models the hours of operation"""
    monday_open = TimeProperty()
    monday_close = TimeProperty()
    tuesday_open = TimeProperty()
    tuesday_close = TimeProperty()
    wednesday_open = TimeProperty()
    wednesday_close = TimeProperty()
    thursday_open = TimeProperty()
    thursday_close = TimeProperty()
    friday_open = TimeProperty()
    friday_close = TimeProperty()
    saturday_open = TimeProperty()
    saturday_close = TimeProperty()
    sunday_open = TimeProperty()
    sunday_close = TimeProperty()
    exceptions = ListProperty(DateExeption)

class DateExeption(db.Model):
    """Models an exception from the regular hours of operation"""
    date = db.DateProperty()
    new_open = db.TimeProperty()
    new_close = db.TimeProperty()

class Winery(db.Model):
    """Models a winery"""
    name = db.StringProperty(required=True)
    description = db.TextProperty()
    hours = db.ListProperty()
    rating = db.RatingProperty()
    email = db.EmailProperty()
    phone = db.PhoneNumberProperty()
    hours = db.ReferenceProperty(WeeklyHours)
    
class Event(db.Model):
    """Models an event"""
    title = db.StringProperty(required=True);
    description = db.StringProperty();
    start_date = db.DateProperty();
    start_time = db.TimeProperty();
    end_date = db.DateProperty();
    end_time = db.TimeProperty();

class RestServer(webapp.RequestHandler):
    '''
    This class provides a RESTful API that we can use to
    add new tags to as well as view relevant data.
    '''
    
    log = logging.getLogger('API')

    def post(self):
        #pop off the script name ('/api')
        self.request.path_info_pop()

        #Load the JSON values that were sent to the server
        newObject = json.loads(self.request.body, object_hook=hook)
        #Returns the ID that was created
        self.response.write(str(newObject.put().id()))
        result = memcache.get("listeners") or []
        for token in result:
            self.log.info('Sending message to: ' + token)
            channel.send_message(token, self.request.body)
        #This isn't really efficient, but for now, we will refresh the
        #memcache value tags list every time we push a new value to the
        #server.
        taskqueue.add(url='/refresh')
    
    def get(self):
        #pop off the script name ('/api')
        self.request.path_info_pop()

        #forget about the leading '/' and seperate the Data type and the ID
        split = self.request.path_info[1:].split(':')
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
            self.response.write(json.dumps(retrievedEntity, cls=DataEncoder))
    
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

def main():
    application = webapp.WSGIApplication([('/api/.*', RestServer)],
                                         debug=True)
    util.run_wsgi_app(application)


if __name__ == '__main__':
    main()
