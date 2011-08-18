#!/usr/bin/env ruby

require 'rubygems'
require 'cloudfiles'

CF_USERNAME    = "your_rackspace_username_here"
CF_API_KEY     = "your_rackspace_api_key_here"
NUM_TESTS      = 10
CONTAINER_NAME = 'snet_test'

cf_public = CloudFiles::Connection.new(
  :username => CF_USERNAME,
  :api_key  => CF_API_KEY,
  :snet     => false
)

cf_private = CloudFiles::Connection.new(
  :username => CF_USERNAME,
  :api_key  => CF_API_KEY,
  :snet     => true
)

if !cf_public.containers.include?(CONTAINER_NAME)
  cf_public.create_container(CONTAINER_NAME)
end
public_container  = cf_public.container(CONTAINER_NAME)
private_container = cf_private.container(CONTAINER_NAME)

filedata = File.read('testimage.jpg')

public_time  = 0.0
private_time = 0.0

(1..NUM_TESTS).each do |i|
  filename = "public#{i}.jpg"
  t1 = Time.now
  obj = public_container.create_object(filename)
  obj.write(filedata)
  t2 = Time.now
  upload_time = t2 - t1
  public_time += upload_time
  puts "Stored #{filename} in %.4f sec" % upload_time

  filename = "private#{i}.jpg"
  t1 = Time.now
  obj = private_container.create_object(filename)
  obj.write(filedata)
  t2 = Time.now
  upload_time = t2 - t1
  private_time += upload_time
  puts "Stored #{filename} in %.4f sec" % upload_time
end

puts
puts
puts "public time: %.4f" % public_time
puts "private time: %.4f" % private_time

(1..NUM_TESTS).each do |i|
  private_container.delete_object("public#{i}.jpg")
  private_container.delete_object("private#{i}.jpg")
end

cf_public.delete_container(CONTAINER_NAME)

