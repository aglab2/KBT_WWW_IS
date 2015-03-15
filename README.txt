Актуальные проблемы:

1) обработка причин, приводящих к отсутствию глобального ID команды в базе
(причина: команда не была добавлена/распознана грамматикой - кривые пользователи или недостатончо полная грамматика?)

Оставлю упоминания файлов с проблемами на первой грамматике:

-- TestsG1\$\t1\raw\DO.zip_temp.txt\D502-i.txt
Email/тел.: +7(926)354-15-49/volokno@inbox.ru
                            ^
Found symbol / but expected nl @ w n ] [ # , . : p + c


-- TestsG1\$\t1\raw\ST.zip_temp.txt\E503-i.txt
#4 Мамонова Александра Игоревна, 19748
                                      ^
Found symbol nl but expected .


-- TestsG1\$\t2\raw\DO.zip_temp.txt\D502-i.txt
Email/тел.: +7(926)354-15-49/volokno@inbox.ru
                            ^
Found symbol / but expected nl @ w n ] [ # , . : p + c


-- TestsG1\$\t2\raw\DU.zip_temp.txt\DU\C501-i.txt
Error in file C:\Users\Кирилл\Desktop\KBT_WWW_IS\Grammar\TestsG1\$\t2\raw\DU.zip_temp.txt\DU\C501-i.txt in line 32
#2 Плешанова Светлана Борисовна, 28.02.1997, -
                                            ^^
Found symbol c but expected n nl


-- TestsG1\$\t2\raw\KO.zip_temp.txt\F507-i.txt
#5 Кулагина Ирина Андреевна, 02.01.1994 69101
                                       ^
Found symbol p but expected nl ,


-- TestsG1\$\t2\raw\pu.zip_temp.txt\pu\Q501-i.txt
л#6 Поздняков Никита Валентинович, 25337
                                        ^
Found symbol nl but expected .


-- TestsG1\$\t3\raw\DO.zip_temp.txt\DO\D502-i.txt
Email/тел.: +7(926)354-15-49/volokno@inbox.ru
                            ^
Found symbol / but expected nl @ w n ] [ # , . : p + c


-- TestsG1\$\t5\raw\DU.zip_temp.txt\DU\C015-i.txt
Email/тел.: assa;nr;/ 89160518145
                    ^
Found symbol / but expected nl @ w n ] [ # , . : p + c


-- TestsG1\$\t6\raw\DU.zip_temp.txt\DU\C015-i.txt
Email/тел.: assa;nr;/ 89160518145
                    ^
Found symbol / but expected nl @ w n ] [ # , . : p + c

2) Написание "Кластера грамматик"
Интересно, что первая грамматика состоит из 3 блоков, поэтому .1 и .2 будем натравлять только на те отчеты которые оказались в списке с флагом false

