  * `latest` built from the [latest PhantomJS snapshot](https://github.com/ariya/phantomjs/commits/master) [![](https://badge.imagelayers.io/wernight/phantomjs:latest.svg)](https://imagelayers.io/?images=wernight/phantomjs:latest 'Get your own badge on imagelayers.io')
  * `2.0.0`, `2.0`, `2` [![](https://badge.imagelayers.io/wernight/phantomjs:2.svg)](https://imagelayers.io/?images=wernight/phantomjs:2 'Get your own badge on imagelayers.io')
  * `1.9.7`, `1.9`, `1` [![](https://badge.imagelayers.io/wernight/phantomjs:1.svg)](https://imagelayers.io/?images=wernight/phantomjs:1 'Get your own badge on imagelayers.io')

[Docker][docker] container of [PhantomJS][phantomjs] is a headless WebKit browser, often used via [WebDriver][webdriver] for web system testing:

 * **Small**: Using [Debian image][debian] is below 100 MB (while Ubuntu is about 230 MB), and removing packages used during build.
 * **Simple**: Exposes default port, easy to extend.
 * **Secure**: Runs as non-root UID/GID `72379` (selected randomly to avoid mapping to an existing user).


### Usage

#### JavaScript interactive shell
 
Start PhantomJS in [REPL](http://phantomjs.org/repl.html):

    $ docker run --rm wernight/phantomjs
    >

#### Remote WebDriver

Start as 'Remote WebDriver mode' (embedded [GhostDriver](https://github.com/detro/ghostdriver)):

    $ docker run -d -p 8910:8910 wernight/phantomjs phantomjs --webdriver=8910

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


### Feedbacks

Improvement ideas and pull requests are welcome via
[Github Issue Tracker](https://github.com/wernight/docker-phantomjs/issues).

[phantomjs]:        http://phantomjs.org/
[docker]:           https://www.docker.io/
[debian]:           https://registry.hub.docker.com/_/debian/
[webdriver]:        http://www.seleniumhq.org/projects/webdriver/
