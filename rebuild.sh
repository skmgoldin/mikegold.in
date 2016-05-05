docker rm -f $(docker ps -a -q)
docker build -t mikegold.in .
docker run -d -p 80:80 -p 8080:8080 mikegold.in /mikegold.in/run.sh
