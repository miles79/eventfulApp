# eventfulApp
Uses google's geochacheing api and eventful's api to search for events given a location, dates, and categories.

Here's a video of it in action: https://youtu.be/2UlXm6CsqQo

I was focused on just getting everything working, so I didn't write any tests.

There are some issues with the images:
  1) I'm not reloading cells when the image gets loaded asyncronously, so they only get loaded if you scroll on the tableview
  2)the last cell gets the same image as the first one (not sure why yet)
  
There is also a slight problem with the calendar date picker, you can select a range greater than 28 days if you try a second time.
