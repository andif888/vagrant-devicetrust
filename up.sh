#!/bin/bash
vagrant up dc

vagrant up rdsh &
vagrant up byod &
vagrant up w10

vagrant up ctrl
