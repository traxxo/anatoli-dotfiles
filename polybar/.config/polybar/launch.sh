#!/bin/bash

polybar-msg cmd quit

echo "---" | tee -a /tmp/mybar.log
polybar mybar 2>&1 | tee -a /tmp/mybar.log & disown

echo "Polybar launched on all monitors..."
