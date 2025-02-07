#!/bin/bash

generate_number() {
    digits=()
    while [[ ${#digits[@]} -lt 4 ]]; do
        digit=$((RANDOM % 10))
        if [[ ${#digits[@]} -eq 0 && $digit -eq 0 ]]; then
            continue  # Первая цифра не может быть 0
        fi
        if [[ ! " ${digits[@]} " =~ " $digit " ]]; then
            digits+=($digit)
        fi
    done
    number=$(printf "%d%d%d%d" "${digits[@]}")
    echo $number
}

validate_input() {
    input=$1
    if [[ $input == "q" || $input == "Q" ]]; then
        echo "quit"
    elif [[ $input =~ ^[0-9]{4}$ ]] && [[ $(echo $input | grep -o . | sort | uniq -d | wc -l) -eq 0 ]]; then
        echo "valid"
    else
        echo "invalid"
    fi
}

count_cows_and_bulls() {
    guess=$1
    cows=0
    bulls=0

    for i in {0..3}; do
        if [[ ${guess:$i:1} -eq ${number:$i:1} ]]; then
            ((bulls++))
        elif [[ $number == *${guess:$i:1}* ]]; then
            ((cows++))
        fi
    done

    echo "$cows $bulls"
}

number=$(generate_number)
history=()
attempt=1

echo "********************************************************************************"
echo "* Я загадал 4-значное число с неповторяющимися цифрами. На каждом ходу делайте *"
echo "* попытку отгадать загаданное число. Попытка - это 4-значное число с           *"
echo "* неповторяющимися цифрами.                                                    *"
echo "********************************************************************************"

while true; do
    read -p "Попытка $attempt: " guess

    case $(validate_input $guess) in
        "quit")
            echo "Выход из игры."
            exit 1
            ;;
        "valid")
            result=$(count_cows_and_bulls $guess)
            cows=$(echo $result | awk '{print $1}')
            bulls=$(echo $result | awk '{print $2}')

            history+=("$attempt. $guess (Коров - $cows Быков - $bulls)")

            echo "Коров - $cows Быков - $bulls"
            echo "История ходов:"
            for line in "${history[@]}"; do
                echo "$line"
            done

            if [[ $bulls -eq 4 ]]; then
                echo "Поздравляем! Вы угадали число $number."
                exit 0
            fi

            ((attempt++))
            ;;
        "invalid")
            echo "Ошибка ввода. Пожалуйста, введите 4-значное число с неповторяющимися цифрами или 'q' для выхода."
            ;;
    esac
done
