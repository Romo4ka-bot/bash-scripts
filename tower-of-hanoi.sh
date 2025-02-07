#!/bin/bash

# Инициализация стеков
declare -a A=(8 7 6 5 4 3 2 1)
declare -a B=()
declare -a C=()
move_number=1

display_stacks() {
    echo "Ход № $move_number"
    for i in {7..0}; do
        echo -n "|${A[$i]:- }|  |${B[$i]:- }|  |${C[$i]:- }|"
        echo
    done
    echo "+-+  +-+  +-+"
    echo " A    B    C"
}

check_win() {
    if [[ "${B[*]}" == "8 7 6 5 4 3 2 1" || "${C[*]}" == "8 7 6 5 4 3 2 1" ]]; then
        echo "Поздравляем! Вы выиграли!"
        exit 0
    fi
}

get_top() {
    local stack_name=$1
    local -n stack=$stack_name
    if [[ ${#stack[@]} -gt 0 ]]; then
        echo "${stack[-1]}"
    else
        echo ""
    fi
}

pop() {
    local stack_name=$1
    local -n stack=$stack_name
    if [[ ${#stack[@]} -gt 0 ]]; then
        unset 'stack[-1]'
    fi
}

push() {
    local stack_name=$1
    local value=$2
    local -n stack=$stack_name
    stack+=("$value")
}

while true; do
    display_stacks
    read -p "Ход № $move_number (откуда, куда): " input

    input=$(echo "$input" | tr '[:lower:]' '[:upper:]' | tr -d ' ')

    if [[ $input == "Q" || $input == "q" ]]; then
        echo "Игра завершена."
        exit 1
    fi

    if [[ ${#input} -ne 2 || ! "ABC" =~ "${input:0:1}" || ! "ABC" =~ "${input:1:1}" ]]; then
        echo "Ошибка ввода. Пожалуйста, введите два корректных имени стеков (например, AB или AC)."
        continue
    fi

    from=${input:0:1}
    to=${input:1:1}

    if [[ $from == $to ]]; then
        echo "Ошибка: нельзя перемещать элемент в тот же стек."
        continue
    fi

    top_from=$(get_top "$from")
    if [[ -z $top_from ]]; then
        echo "Стек $from пуст."
        continue
    fi

    top_to=$(get_top "$to")
    if [[ -n $top_to && $top_to -lt $top_from ]]; then
        echo "Такое перемещение запрещено: нельзя положить $top_from на $top_to."
        continue
    fi

    pop "$from"
    push "$to" "$top_from"
    ((move_number++))

    check_win
done