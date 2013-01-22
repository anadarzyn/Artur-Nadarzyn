#!/bin/bash

# funkcja dająca wybór wielkości macierzy dla której będzie obliczany wyznacznik
start()
{
    # w zależności od wyboru wielkości macierzy wywołuję fukcję enter_tab()
    # (do wprowadzenia tablicy) z odpowiednim parametrem ("3" lub "4")
    # i odpowiednią funkcję det3x3() lub det4x4()
    echo Wybierz rozmiar macierzy. Opcja 1 lub 2.
    rozmiary="3x3 4x4"
           select rozmiar in $rozmiary; do
               if [ "$rozmiar" = "3x3" ]; then
                enter_tab 3
                # parametr "podajwynik" gdyż chcemy aby funkcja wydrukowała wynik
                det3x3 tab1[@] tab2[@] tab3[@] podajwynik
               elif [ "$rozmiar" = "4x4" ]; then
                # funkcja det4x4() nie potrzebuje tablic jako parametrów ponieważ korzysta
                # z tablic zapisanych globalnie
                enter_tab 4
                det4x4
               else
                echo Niewłaściwy wybór!
                echo Naciśnij Enter i wybierz rozmiar macierzy jeszcze raz. Opcja 1 lub 2.
               fi
           done
}


# Wprowadzenie tablicy
enter_tab()
{
    # w zależności od parametru $1 (4 dla macierzy 4x4) drukuje odpowiedni komunikat
    if [ $1 == 4 ]; then
        printf "\nPodaj elementy macierzy 4x4. \n \n"
    else
        printf "\nPodaj elementy macierzy 3x3. \n \n"
    fi

    # wpisuj wartości do tablic dopóki funkcja check_if_correct() nie przypisze
    # pozytywnej wartości do zmiennej "correct" czyli dopóki wszystkie elementy
    # będą poprawne (czyli typu integer) oraz liczba elementów będzie właściwa
    correct=0
    while [[ $correct == 0 ]]; do
        printf "Pierwszy wiersz:\n"
        read -a tab1
        check_if_correct tab1[@] $1
    done

    correct=0
    while [[ $correct == 0 ]]; do
        printf "Drugi wiersz:\n"
        read -a tab2
        check_if_correct tab2[@] $1
    done

    correct=0
    while [[ $correct == 0 ]]; do
        printf "Trzeci wiersz:\n"
        read -a tab3
        check_if_correct tab3[@] $1
    done


    # program oczekuje wprowadzenia 4-go wiersza tylko jeśli parametr podany był dla macierzy 4x4
    if [ $1 == 4 ]; then
        correct=0
        while [[ $correct == 0 ]]; do
            printf "Czwarty wiersz:\n"
            read -a tab4
            check_if_correct tab4[@] $1
        done
        fi


    # Kontrolny wydruk tablicy

    # printf "\n \nTablica: \n\n"
    # echo ${tab1[@]}
    # echo ${tab2[@]}
    # echo ${tab3[@]}
    # echo ${tab4[@]}
}

# funkcja sprawdza czy podane elementy są liczbami całkowitymi
# oraz czy podano prawidłową ilość elementów
# $1 tablica $2 oczekiwana ilość elementów tablicy
check_if_correct()
{
    correct=1

    # przypisanie tablicy z argumentu
    declare -a tab_check=("${!1}")


    # sprawdzenie czy elementy są typu integer

    # pętla sprawdza wszystkie elemeny tablicy
    for ((i=0; i < ${#tab_check[@]}; i++))
        do
        # jeśli do tej pory nie wykryto błędu to sprawdza dalej
        if [ $correct == 1 ]; then
              element=${tab_check[$i]}
              # sprawdza czy zmienna równa lub różna od zera, zwraca wartość pozytywną (true)
              # dla liczb całkowitych (typ integer)
              # dla innych znaków oddaje error (przekierowany)
            if ! [ $element -ne 0 -o $element -eq 0 2>/dev/null ]; then
                correct=0
            fi
        fi
    done

        if [ $correct == 0 ]; then
            echo "Błąd: nieprawidłowy element. Tylko liczby całkowite są dozwolone."
        fi


    # sprawdzenie czy tablica zawiera odpowiednią ilość elementów

    # jeśli test na poprawność elementów zakończył się pozytywnie sprawdza ich ilość
    if [ $correct == 1 ]; then
    # porównuje liczbę elemntów tablicy z argumentem $2 który zawiera jej oczekiwany rozmiar
        if [ ${#tab_check[@]} != $2 ]; then
            correct=0
        fi
        if [ $correct == 0 ]; then
            echo "Błąd: nieprawidłowa ilość elementów. Wprowadź $2 elementy."
        fi
    fi
}


# funkcja kopiujaca do tablic pomocniczych z tablic podanych przez uzytkownika
# aby umozliwic ich modyfikacje (wykreslanie kolumn)
copy_tab()
{
    tab_tmp1=("${tab1[@]}")
    tab_tmp2=("${tab2[@]}")
    tab_tmp3=("${tab3[@]}")
    tab_tmp4=("${tab4[@]}")

}

# funkcja liczaca wyznacznik macierzy 3x3
det3x3()
{
    # wczytanie tablic podanych funkcji jako argumenty
    declare -a tabf1=("${!1}")
    declare -a tabf2=("${!2}")
    declare -a tabf3=("${!3}")

    # obliczenie składnikow wyznacznika
    a=$((${tabf1[0]}*${tabf2[1]}*${tabf3[2]}))
    b=$((${tabf2[0]}*${tabf3[1]}*${tabf1[2]}))
    c=$((${tabf3[0]}*${tabf1[1]}*${tabf2[2]}))
    d=$((${tabf1[2]}*${tabf2[1]}*${tabf3[0]}))
    e=$((${tabf2[2]}*${tabf3[1]}*${tabf1[0]}))
    f=$((${tabf3[2]}*${tabf1[1]}*${tabf2[0]}))


    # zapisanie wyniku do globalnej zmiennej
    det3x3_result=$(($a+$b+$c-$d-$e-$f))

    # kontrolny wydruk wynikow obliczen
    # echo $det3x3_result

    # jeśli funkcja była wywołana z odpowiednim parametrem $4 - "podajwynik" (kiedy użytkownik
    # wybrał macierz 3x3 ) to drukuje wynik obliczeń
    # i kontynułuję działanie wywołując funkcję continue()
    if [ $4 == "podajwynik" ]; then
        printf "\nWyznacznik macierzy : $det3x3_result \n\n"
        continue
    fi

}


# funkcja licząca wyznacznik macierzy 4x4 na podstawie dopełnień algebraicznych przy użyciu
# funkcji det3x3()
det4x4()
{
    # inicjacja wyniku wyznacznika i znaku dopełnienia algebraicznego(zawsze 1 albo -1)
    det4x4_result=0
    znak=-1

    # petla obliczaja dopelnienia algebraiczne przy uzyciu funkcji det3x3
    # poprzez wykreslanie kolumn (wykresla kolumne [index])
    for index in `seq 0 3`; do
        copy_tab # skopiowanie tablic zeby umozliwic ich bezproblemowa modyfikacje

        # tworzy nowa tablice z dwoch czesc starej tablicy, pomijajac element o indeksie [index]
        tab_tmp1=(${tab_tmp1[@]:0:$index} ${tab_tmp1[@]:$(($index + 1))})
        tab_tmp2=(${tab_tmp2[@]:0:$index} ${tab_tmp2[@]:$(($index + 1))})
        tab_tmp3=(${tab_tmp3[@]:0:$index} ${tab_tmp3[@]:$(($index + 1))})

        # kontrola poprawnosci tablic pomocniczych
        # echo ${tab_tmp1[@]}
        # echo ${tab_tmp2[@]}
        # echo ${tab_tmp3[@]}

        # odwoluje sie do funkcji det3x3() ze zmodyfikowanymi tablicami jako parametrami
        # aby obliczyc dopelnienie algebraiczne,
        # "nope" - dowolny parametr różny od "podajwynik"
        det3x3 tab_tmp1[@] tab_tmp2[@] tab_tmp3[@] nope

        # przypisanie wynikowi funkcji det3x3() (przechowywanej w globalnej zmiennej) odpowiedniego znaku
        det3x3_result=$(($det3x3_result*$znak*tab4[$index]))

        # uaktualnienie wyniku funkcji
        det4x4_result=$(($det4x4_result+$det3x3_result))

        # zmiana znaku na przeciwny (zawsze 1 albo -1)
        znak=$(($znak*(-1)))

    done
        # wydruk wyniku
        printf "\nWyznacznik macierzy : $det4x4_result \n\n"
        # kontynuacja działania
        continue
}


# funkcja kończąca lub kontynująca działanie programu
# wywoływana po obliczeniu wyznacznika
continue()
{
    # tymczasowa zmiana Internal Field Separator aby umożliwić dwuwyrazową opcję
    # zastąpienie " "  tym  "."
    OLD_IFS=${IFS}; IFS=".";
    opcje="Następna macierz.Wyjdź"
    select opcja in $opcje; do
        # powrót do orginalnego IFS
        IFS=${OLD_IFS}
        if [ "$opcja" = "Następna macierz" ]; then
            echo
            start
        elif [ "$opcja" = "Wyjdź" ]; then
            echo
            exit
        else
            echo Niewłaściwy wybór!
            echo Naciśnij Enter i wybierz jeszcze raz. Opcja 1 lub 2.
            fi
        done

}

# inicjacja działania
printf "\nSkrypt do obliczania wyznacznika macierzy 3x3 albo 4x4. \nDla liczb całkowitych.\n\n"
start