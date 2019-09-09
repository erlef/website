// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

import "phoenix_html"

// Import local files
//

import { Calendar } from '@fullcalendar/core';
import interactionPlugin from '@fullcalendar/interaction';
import dayGridPlugin from '@fullcalendar/daygrid';
import listPlugin from '@fullcalendar/list';
import bootstrapPlugin from '@fullcalendar/bootstrap';
import googleCalendarPlugin from '@fullcalendar/google-calendar';
import 'bootstrap';

document.addEventListener('DOMContentLoaded', function() {
    var calendarEl = document.getElementById('calendar');

    if (calendarEl != null) { 
        var defaultView = calendarEl.getAttribute("data-calendar-type") || "dayGridMonth";

        var gcal_id = calendarEl.getAttribute("data-gcal-id");
        var gcal_api_key= calendarEl.getAttribute("data-gcal-api-key");
        var calendar_opts;
        if ( gcal_api_key != null) {
            calendar_opts = [ 
             {
                googleCalendarId: gcal_id
              },
              window.calendar_events
            ];
        } else { 
            calendar_opts = [ 
              window.calendar_events
            ];
        }

        var header;
        if (calendarEl.getAttribute("data-calendar-header") === "true") {
            header = {
                left: 'prev,next',
                center: 'title',
                right: 'dayGridMonth,dayGridWeek,dayGridDay,listMonth'
            };
        } else { 
            header = '';
        }

        var navLinks;

        if (calendarEl.getAttribute("data-calendar-header") === "true") { 
            navLinks = true;
        } else { 
            navLinks = false;
        }

        var calendar = new Calendar(calendarEl, {
            plugins: [interactionPlugin, dayGridPlugin, listPlugin, bootstrapPlugin, googleCalendarPlugin],
            header: header, 
            navLinks: navLinks,
            themeSystem: 'bootstrap',
            defaultView: defaultView,
            timeZone: "UTC",
            visibleRange: function(currentDate) {
                var startDate = new Date(currentDate.valueOf());
                var endDate = new Date(currentDate.valueOf());
                startDate.setDate(startDate.getDate() - 1); // One day in the past
                endDate.setDate(endDate.getDate() + 90); // 3 monts roughly into the future
                return { start: startDate, end: endDate };
            },
            eventLimit: true,
            allDaySlot: true,
            displayEventTime: true,
            displayEventEnd: true,
            firstDay: 1,
            weekNumbers: false,
            selectable: false,
            weekNumberCalculation: "ISO",
            eventLimit: true,
            eventLimitClick: 'week', //popover
            slotLabelFormat: 'HH:mm',
            weekends: true,
            nowIndicator: true,
            dayPopoverFormat: 'dddd DD/MM',
            googleCalendarApiKey: gcal_api_key,
            eventSources: calendar_opts, 
            eventRender: function (info) {
                $(info.el).popover({
                    title: info.event.title,
                    content: info.event.extendedProps.description,
                    trigger: 'hover',
                    placement: 'top',
                    container: 'body'
                });
            }
        });

        calendar.render();
    }
});

