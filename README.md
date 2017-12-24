# Supported tags and respective `Dockerfile` links

  * [`latest`](https://github.com/wernight/docker-phantomjs/blob/master/Dockerfile) built from the [latest PhantomJS snapshot](https://github.com/ariya/phantomjs/commits/master) [![](https://images.microbadger.com/badges/image/wernight/phantomjs.svg)](http://microbadger.com/images/wernight/phantomjs "Get your own image badge on microbadger.com")
  * [`2`, `2.1`, `2.1.1`](https://github.com/wernight/docker-phantomjs/blob/v2.1.1/Dockerfile) [![](https://images.microbadger.com/badges/image/wernight/phantomjs:2.1.svg)](http://microbadger.com/images/wernight/phantomjs "Get your own image badge on microbadger.com")
  * [`2.0`, `2.0.0`](https://github.com/wernight/docker-phantomjs/blob/v2.0.0/Dockerfile) [![](https://images.microbadger.com/badges/image/wernight/phantomjs:2.0.svg)](http://microbadger.com/images/wernight/phantomjs "Get your own image badge on microbadger.com")
  * [`1`, `1.9`, `1.9.7`](https://github.com/wernight/docker-phantomjs/blob/v1.9.7/Dockerfile) [![](https://images.microbadger.com/badges/image/wernight/phantomjs:1.svg)](http://microbadger.com/images/wernight/phantomjs "Get your own image badge on microbadger.com")

## What is PhantomJS

[PhantomJS][phantomjs] is a headless WebKit browser, often used via [WebDriver][webdriver] for web system testing.
It's based on WebKit, runs JavaScript, and allows to take screenshots.


## Features of this image

This [Dockerized][docker] version of PhantomJS is:

 * **Small**: Using [Debian image][debian] (below 100 MB, while Ubuntu is about 230 MB), and removing packages used during build.
 * **Simple**: Exposes default port, easy to extend.
 * **Secure**: Runs as non-root UID/GID `72379` (selected randomly to avoid mapping to an existing user) and uses [dumb-init](https://github.com/Yelp/dumb-init) to reap zombie processes.


## Usage

### JavaScript interactive shell
 
Start PhantomJS in [REPL](http://phantomjs.org/repl.html):

    $ docker run --rm wernight/phantomjs
    >

### Remote WebDriver

Start as 'Remote WebDriver mode' (embedded [GhostDriver](https://github.com/detro/ghostdriver)):

    $ docker run -d -p 8910:8910 wernight/phantomjs --webdriver=8910

To connect to it (some examples per language):

  * Java:

        WebDriver driver = new RemoteWebDriver(
            new URL("http://127.0.0.1:8910"),
            DesiredCapabilities.phantomjs());

  * Python (after running [`$ pip install selenium`](https://pypi.python.org/pypi/selenium/)):
  
        from selenium import webdriver
        from selenium.webdriver.common.desired_capabilities import DesiredCapabilities

        driver = webdriver.Remote(
            command_executor='http://127.0.0.1:8910',
            desired_capabilities=DesiredCapabilities.PHANTOMJS)

        driver.get('http://example.com')
        driver.find_element_by_css_selector('a[title="hello"]').click()
        
        driver.quit()


## Feedbacks

Improvement ideas and pull requests are welcome via
[Github Issue Tracker](https://github.com/wernight/docker-phantomjs/issues).

[phantomjs]:        http://phantomjs.org/
[docker]:           https://www.docker.io/
[debian]:           https://registry.hub.docker.com/_/debian/
[webdriver]:        http://www.seleniumhq.org/projects/webdriver/
