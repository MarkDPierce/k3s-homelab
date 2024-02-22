Fresh Deploy
___
Remove the line in docker-compose.yaml `- data:/var/www/FreshRSS/data`
Remove the `config.custom.php` file from /data/

Run your docker-compose and finish setting up FreshRSS via the browser. When completed there should be a directory called data with a `config.custom.php` file in it.
Add `- data:/var/www/FreshRSS/data` back to the docker-compose file under volumes.
