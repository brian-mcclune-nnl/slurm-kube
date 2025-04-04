#!/bin/bash

sacctmgr --immediate create account name=all
sacctmgr --immediate create user name=alice account=all share=1
sacctmgr --immediate create user name=bob account=all share=1
sacctmgr --immediate create user name=carol account=all share=1
