#!/bin/bash

# stops puma server running in background

# ingnores errors which could occur if the server is not running

pgrep -f puma | xargs kill 2>/dev/null