import { Calendar } from '@fullcalendar/core';
import dayGridPlugin from '@fullcalendar/daygrid';
import bootstrapPlugin from '@fullcalendar/bootstrap';
import rrulePlugin from '@fullcalendar/rrule';
import * as ICAL from 'ical.js'
import { DateTime } from "luxon";

function build_event(vevent) {
  event = new ICAL.Event(vevent); 
  var start = new Date(event.startDate.toUnixTime() * 1000).toISOString();
  var end = (event.endDate ? new Date(event.endDate.toUnixTime() * 1000).toISOString() : null);

  if (event.isRecurring) {
    var recur_rules = event.iterator().toJSON().ruleIterators[0].rule;
    return {
        title: event.summary,
        start: start,
        end: end,
        description: event.description,
        location: event.location,
        rrule: {
            freq: recur_rules.freq,
            interval: recur_rules.interval,
            dtstart: start
        },
        duration: '1:00',
        allDay: false
    }
  } else { 
    return {
        title: event.summary,
        start: start,
        end: end,
        description: event.description,
        location: event.location
    }
  }
}

document.addEventListener('DOMContentLoaded', function() {
    var calendarEl = document.getElementById('calendar');

    if (calendarEl != null) { 
        var defaultView = calendarEl.getAttribute("data-calendar-type") || "dayGridMonth";

        var ics_url = calendarEl.getAttribute("data-calendar-ics-url");
        var events = [
            { 
                events: function(fetchInfo, successCallback, failureCallback) { 
                        var xhr = new XMLHttpRequest();
                        xhr.open('GET', ics_url, true);   
                        xhr.onload = function () {
                            var iCalFeed = ICAL.parse(xhr.responseText);
                            var iCalComponent = new ICAL.Component(iCalFeed);
                            var vtimezones = iCalComponent.getAllSubcomponents("vtimezone");
                            vtimezones.forEach(function (vtimezone) {
                            if (!(ICAL.TimezoneService.has(
                                vtimezone.getFirstPropertyValue("tzid")))) {
                                ICAL.TimezoneService.register(vtimezone);
                            }
                            });

                            var ical_events = iCalComponent.getAllSubcomponents('vevent');
                            successCallback(ical_events.map(build_event)); 
                        }
                        xhr.send();
                }}];

        var navLinks;

        if (calendarEl.getAttribute("data-calendar-header") === "true") { 
            navLinks = true;
        } else { 
            navLinks = false;
        }


        var calendar = new Calendar(calendarEl, {
            plugins: [rrulePlugin, dayGridPlugin, bootstrapPlugin],
            navLinks: navLinks,
            themeSystem: 'bootstrap',
            timeZone: "local",
            visibleRange: function(currentDate) {
                var startDate = new Date(currentDate.valueOf());
                var endDate = new Date(currentDate.valueOf());
                startDate.setDate(startDate.getDate() - 1); // One day in the past
                endDate.setDate(endDate.getDate() + 90); // 3 monts roughly into the future
                return { start: startDate, end: endDate };
            },
            displayEventTime: true,
            displayEventEnd: true,
            firstDay: 1,
            weekNumbers: false,
            selectable: false,
            weekNumberCalculation: "ISO",
            eventLimit: true,
            slotLabelFormat: 'HH:mm',
            weekends: true,
            nowIndicator: true,
            dayPopoverFormat: 'dddd DD/MM',
            eventSources: events,
            eventClick: function (info) {
               var event = info.event; 
               var dtstart = DateTime.fromJSDate(event.start); 
               var dtend =  DateTime.fromJSDate(event.end);
                $('.modal').find('.title').text(event.title);
                $('.modal').find('.starts-at').text(dtstart.toLocaleString(DateTime.DATETIME_FULL));
                $('.modal').find('.ends-at').text(dtend.toLocaleString(DateTime.DATETIME_FULL));
                if (event.description) { 
                    $('.modal').find('.description').text(event.description);
                } else {
                    $('.modal').find('.description-label').hide();
                }
                if (event.extendedProps.location) { 
                    $('.modal').find('.location').text(event.extendedProps.location);
                } else {
                    $('.modal').find('.location-label').hide();
                }
 
                $('.modal').modal('show');
            }
        });

        calendar.render();
    }
});

