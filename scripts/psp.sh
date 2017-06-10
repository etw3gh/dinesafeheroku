#!/bin/bash
# see if the rails app is running in the background
ps aux | grep puma | grep -v grep
