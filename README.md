# Fenix (Феникс, Phoenix) WEB App

(public/static/images/qr_code.png)

## В разработке...

В данный момент публикация сервера производится через root@fx.navi.cc



## То, что описано дальше, пока не используется.

```
useradd -m fx.navi.cc -d /var/www/fx.navi.cc -s /bin/bash
usermod -aG www-data fx.navi.cc
passwd fx.navi.cc
```

С рабочей машины скопируем ключи

Если ключи еще не были сгенерированя, нужно выполнить:
```
ssh-keygen -q
```

```
ssh-copy-id fx.navi.cc@fx.navi.cc
```

После этого можно заходить:

```
ssh fx.navi.cc@fx.navi.cc
```


## Планы.

https://github.com/marshallformula/elm-swiper
