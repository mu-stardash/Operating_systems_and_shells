#!/bin/bash
##########################################################################
# Сценарий:  a.sh - вывод чисел в разных системах счисления
# Автор: Efimova Dasha (dashulya0303178@gmail.com)
# Дата: 23.05.2020
##########################################################################

Name=`basename "$0"`                             # Имя программы

# Help - функция вывода сообщения об использовании программы 
Help () {
    echo "$Name - number output in various nember systems
Order of use: $Name [number ...]

If the number is not specified, then input from stdin  is performed.

The number can be:
	the binary - must start with the character combination 0b (for example, 0b1100)
	octal - must start with 0 (for example, 014)
	hexadecimal - must start with a combination of 0x characters (for example, 0xc)
	decimal - in any other case (for example 12)"
    exit 0
}

# Message - функция ля вывода сообщений о вводе неверных параметров
Message () {
    for i   # список слов не указан, i принимает значения из списка позиционных параметров
    do 
		echo "$Name: $i"
    done
}

# Bases - функция для определения системы счисления вводимых чисел
Bases () {

    for i      # список слов не указан, i принимает значения из списка позиционных параметров
    do        
        case "$i" in
            0b*)                ibase=2;;       # введена двоичная с.с., если начинается с '0b'
            0x*|[a-f]*|[A-F]*)  ibase=16;;      # введена шестнадцатиричная с.с., если начинается '0x' или буквы латинского алфавита (загл. или маленькой) 
            0*)                 ibase=8;;       # введена восьмеричная с.с., если начинаетсч с '0'
            [1-9]*)             ibase=10;;      # введена десятичная с.с., если начинается с цифры
            *)									# если введен другой символ, то выводим сообщение 
                Message "Error in the number $i - the number was ignored"
                continue;;
        esac

        # Удалить префикс и преобразовать шестнадцатиричные цифры в верхний регистр (этого требует bc)
        number=`echo "$i" | sed -e 's/^0[bBxX]//' | tr '[a-f]' '[A-F]'`

        # Преобразование number в десятичную систему счисления (по умолчанию obase = 10)
        dec=`echo "ibase=$ibase; $number" | bc`  # bc используется как калькулятор
        case "$dec" in
            [0-9]*)     ;;         # все в порядке
            *)          continue;; # ошибка, игноририруем
        esac

        # Напечатаем все преобразования в одну строку, используя 'вложенный документ' - список команд для 'bc' (<<TEXT...TEXT)
        echo `bc <<TEXT
            obase=16; "hex="; $dec
            obase=10; "dec="; $dec
            obase=8;  "oct="; $dec
            obase=2;  "bin="; $dec
TEXT` | sed -e 's: :       :g' # сделаем большее расстояние между выводивыми значениями

    done
}

# если есть позиц.параметры, то смотрим какие
while [ ${#} -gt 0 ]
do
    case "$1" in
        -h)     Help;;          # Вывод справочного сообщения.
        -*)     Help;;
         *)     break;;         # первое число
    esac  
done

# если есть позиц.параметры, то сразу выводим их с помощью функции Bases
if [ ${#} -gt 0 ]
then
    Bases "${@}"
else                                    # если нет, то читаем с stdin
    while read line
    do
        Bases $line
    done
fi