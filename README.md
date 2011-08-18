This is a quick-and-dirty script to compare the performance of uploading from a Rackspace Cloud Server instance to a Rackspace Cloud Files container over the public network vs the private network (a.k.a. ServiceNet or snet). It's not very scientific at the moment, but a few runs seem to demonstrate the performance difference pretty consistently. I'm sure a a more detailed analysis of the individual timings would show that even though the two don't seem that different most of the time, the public interface is much more prone to large outliers that take WAY too long to upload.

To run this test yourself:

```
git clone git://github.com/scottwb/cloudfiles-snet-bench.git
gem install cloudfiles   # or use bundler with the Gemfile
```

Then, edit run.rb and fill in your username, api_key, and set how many runs you want.

```ruby
CF_USERNAME = "your_rackspace_username_here"
CF_API_KEY  = "your_rackspace_api_key_here"
NUM_TESTS   = 10
```

Now run the command:

```
ruby run.rb
```

This will create a container named 'snet_test', upload an image file that is just under a megabyte, `NUM_TESTS * 2` times - half over the public network, half over the private network. It prints out timing info for each upload, and a cululative time at the end.

For example:

```
[deploy@beta cloudtest]$ ./cloudtest.rb 
Stored public1.jpg in 0.1707 sec
Stored private1.jpg in 0.0866 sec
Stored public2.jpg in 0.1604 sec
Stored private2.jpg in 0.1544 sec
...
Stored public98.jpg in 0.2943 sec
Stored private98.jpg in 0.1261 sec
Stored public99.jpg in 0.2589 sec
Stored private99.jpg in 0.8079 sec
Stored public100.jpg in 0.1488 sec
Stored private100.jpg in 0.2480 sec


public time: 223.6589
private time: 84.0721
```
