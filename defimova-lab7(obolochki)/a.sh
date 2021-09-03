#!/bin/bash
##########################################################################
# ��������:  a.sh - ����� ����� � ������ �������� ���������
# �����: Efimova Dasha (dashulya0303178@gmail.com)
# ����: 23.05.2020
##########################################################################

Name=`basename "$0"`                             # ��� ���������

# Help - ������� ������ ��������� �� ������������� ��������� 
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

# Message - ������� �� ������ ��������� � ����� �������� ����������
Message () {
    for i   # ������ ���� �� ������, i ��������� �������� �� ������ ����������� ����������
    do 
		echo "$Name: $i"
    done
}

# Bases - ������� ��� ����������� ������� ��������� �������� �����
Bases () {

    for i      # ������ ���� �� ������, i ��������� �������� �� ������ ����������� ����������
    do        
        case "$i" in
            0b*)                ibase=2;;       # ������� �������� �.�., ���� ���������� � '0b'
            0x*|[a-f]*|[A-F]*)  ibase=16;;      # ������� ����������������� �.�., ���� ���������� '0x' ��� ����� ���������� �������� (����. ��� ���������) 
            0*)                 ibase=8;;       # ������� ������������ �.�., ���� ���������� � '0'
            [1-9]*)             ibase=10;;      # ������� ���������� �.�., ���� ���������� � �����
            *)									# ���� ������ ������ ������, �� ������� ��������� 
                Message "Error in the number $i - the number was ignored"
                continue;;
        esac

        # ������� ������� � ������������� ����������������� ����� � ������� ������� (����� ������� bc)
        number=`echo "$i" | sed -e 's/^0[bBxX]//' | tr '[a-f]' '[A-F]'`

        # �������������� number � ���������� ������� ��������� (�� ��������� obase = 10)
        dec=`echo "ibase=$ibase; $number" | bc`  # bc ������������ ��� �����������
        case "$dec" in
            [0-9]*)     ;;         # ��� � �������
            *)          continue;; # ������, ������������
        esac

        # ���������� ��� �������������� � ���� ������, ��������� '��������� ��������' - ������ ������ ��� 'bc' (<<TEXT...TEXT)
        echo `bc <<TEXT
            obase=16; "hex="; $dec
            obase=10; "dec="; $dec
            obase=8;  "oct="; $dec
            obase=2;  "bin="; $dec
TEXT` | sed -e 's: :       :g' # ������� ������� ���������� ����� ���������� ����������

    done
}

# ���� ���� �����.���������, �� ������� �����
while [ ${#} -gt 0 ]
do
    case "$1" in
        -h)     Help;;          # ����� ����������� ���������.
        -*)     Help;;
         *)     break;;         # ������ �����
    esac  
done

# ���� ���� �����.���������, �� ����� ������� �� � ������� ������� Bases
if [ ${#} -gt 0 ]
then
    Bases "${@}"
else                                    # ���� ���, �� ������ � stdin
    while read line
    do
        Bases $line
    done
fi