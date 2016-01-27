```
docker build -t pintostack .
```

```
docker run -d -v $(pwd)/conf:/pintostack/conf -v $(pwd)/.vagrant:/pintostack/.vagrant pintostack
```

```
docker exec -it <containerSha> bash 
```


```
cd /pintostack
./pintostack.sh aws
```
