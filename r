#!/bin/bash

# Run applications in background and detach them completely

nohup "$@" >/dev/null 2>&1 &

