# Text calendar

Pascal program writing a calendar in plain text format.

```

                                                                   Année 2025                                                                   

          Janvier                 Février                  Mars                    Avril                    Mai                    Juin         
    Di Lu Ma Me Je Ve Sa    Di Lu Ma Me Je Ve Sa    Di Lu Ma Me Je Ve Sa    Di Lu Ma Me Je Ve Sa    Di Lu Ma Me Je Ve Sa    Di Lu Ma Me Je Ve Sa
              1  2  3  4                       1                       1           1  2  3  4  5                 1  2  3     1  2  3  4  5  6  7
     5  6  7  8  9 10 11     2  3  4  5  6  7  8     2  3  4  5  6  7  8     6  7  8  9 10 11 12     4  5  6  7  8  9 10     8  9 10 11 12 13 14
    12 13 14 15 16 17 18     9 10 11 12 13 14 15     9 10 11 12 13 14 15    13 14 15 16 17 18 19    11 12 13 14 15 16 17    15 16 17 18 19 20 21
    19 20 21 22 23 24 25    16 17 18 19 20 21 22    16 17 18 19 20 21 22    20 21 22 23 24 25 26    18 19 20 21 22 23 24    22 23 24 25 26 27 28
    26 27 28 29 30 31       23 24 25 26 27 28       23 24 25 26 27 28 29    27 28 29 30             25 26 27 28 29 30 31    29 30               
                                                    30 31                                                                                       

          Juillet                  Août                  Septembre                Octobre                Novembre                Décembre       
    Di Lu Ma Me Je Ve Sa    Di Lu Ma Me Je Ve Sa    Di Lu Ma Me Je Ve Sa    Di Lu Ma Me Je Ve Sa    Di Lu Ma Me Je Ve Sa    Di Lu Ma Me Je Ve Sa
           1  2  3  4  5                    1  2        1  2  3  4  5  6              1  2  3  4                       1        1  2  3  4  5  6
     6  7  8  9 10 11 12     3  4  5  6  7  8  9     7  8  9 10 11 12 13     5  6  7  8  9 10 11     2  3  4  5  6  7  8     7  8  9 10 11 12 13
    13 14 15 16 17 18 19    10 11 12 13 14 15 16    14 15 16 17 18 19 20    12 13 14 15 16 17 18     9 10 11 12 13 14 15    14 15 16 17 18 19 20
    20 21 22 23 24 25 26    17 18 19 20 21 22 23    21 22 23 24 25 26 27    19 20 21 22 23 24 25    16 17 18 19 20 21 22    21 22 23 24 25 26 27
    27 28 29 30 31          24 25 26 27 28 29 30    28 29 30                26 27 28 29 30 31       23 24 25 26 27 28 29    28 29 30 31         
                            31                                                                      30                                          

```

## Usage

```
make
```

Or, if you prefer the french version:

```
make FRENCH=1
```

And:

```
./demo
```

Or:

```
./demo 2026
```

## First day of week

If you prefer Monday as first of week, edit the configuration file *demo.ini* and replace this line:

```
mondayfirst=0
```

With this one:

```
mondayfirst=1
```
