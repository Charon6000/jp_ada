# Jak uruchomić?
- Sklonuj repozytoroium za pomoca terminala ``` git clone https://github.com/Charon6000/jp_ada.git ```
- Pobierz program [Alire](https://alire.ada.dev/)
- Poprzez terminal Alire "wejdz" do folderu projektu ``` cd jp_ada ```
- Skonfiguruj zależności i kompilator poleceniem ``` alr with ```
- Uruchom projekt poleceniem ``` alr run ```

# Opis projektu
Symulacja centrum logistycznego hipotetycznej firmy zajmującej się sprzętem RTV/AGD.
Towary przyjeżdżają za pomocą ciężarówek, są rozładowywane rozłądowarkami oraz transportowane przez roboty do wnętrza magazynu.

# Wygląd projektu

## Moduł 1 - Dostawy i stanowisko rozładunkowe
- Przyjazd ciężarówki
- Czekanie ciężarówki na rozładowanie
- Informacja o rozpoczęciu rozładunku
- Informacja o zakończeniu rozładunku

Przykładowy przebieg
```
[02.1] Przyjazd samochodu D1
[02.1] D1 oczekuje na rozładunek
[02.3] Rozpoczęto rozładunek D1
[04.3] Zakończono rozładunek D1
```

## Moduł 2 - Roboty transportowe
- Oczekiwanie na polecenie transportu
- Odbieranie informacji o towarze
- Symulacja przejazdu
- Przekazanie towaru do magazynu
- Ponowne oczekiwanie na polecenie

Przykładowy przebieg
```
[04.4] Robot R1 otrzymał 8 szt. towaru A
[05.1] Robot R1 jedzie do magazynu
[07.1] Robot R1 dostarczył towar
[07.1] Robot R1 jest ponownie wolny
```

## Moduł 3 - Magazyn
- przechowuje 3 rodzaje towarów i stan zapelnienia
- przyjmuje towar
- umożliwia sprawdzenie stanu zapełnienia

## MODUŁ E - Ładowanie robotów
- Robot posiada poziom energii
- Transport zmniejsza poziom baterii
- Energii poniżej określonego poziomu robot musi udać się do ładowarki
- Dostępna jest tylko jedna ładowarka, dlatego roboty mogą być zmuszone do oczekiwania

## MODUŁ G - Kontroler / monitor centrum
- Zadanie  okresowo prezentuje stan centrum
- Otrzymuje stan od innych procesów lub okresowo pyta je o aktualny stan

## MODUŁ H - Samochody rezygnujące z oczekiwania
- Samochód nie powinien czekać na rozładunek dowolnie długo
- Jeżeli przez określony czas nie otrzyma dostępu do stanowiska, może odjechać

Przykładowy przebieg:
```
[03.1] D4 oczekuje na rozładunek
[08.1] D4 zrezygnował z oczekiwania
```