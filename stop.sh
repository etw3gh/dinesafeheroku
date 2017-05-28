#!/bin/bash

# stops puma server running in background

pgrep -f puma | xargs kill 2>/dev/null