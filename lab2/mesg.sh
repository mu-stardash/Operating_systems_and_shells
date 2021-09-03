#!/bin/bash

case $(mesg) in
    да)
	echo "Сообщения разрешены"
	;;
    нет)
	echo "Сообщения запрещены"
	;;
    *)
	echo "Что-то не так"
	;;
esac
