#!/bin/bash

send_message() {
    # Send curl message
    curl "GOTIFY_URL" -F "title=$HOSTNAME RAN A TEST" -F "message=TEST SCRIPT PLEASE IGNORE" -F "priority=99"
}

send_message