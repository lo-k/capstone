# Music-Selfie
Turn a video into music

___

##### Config Instructions

- Add a `client_max_body_size` to your `/etc/nginx/nginx.conf` file (in the 'html' context):

        http {
            client_max_body_size 50M; # allows file uploads up to 50 megabytes
            [...]
        }