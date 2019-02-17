# Homework 5
# Task1
Скрипт-аналог ps ax. Выводит PID	TTY	STAT	TIME	COMMAND
# Task2
Simple lsof, written on Haskell. How to run instructions available in README file in task2 dir
# Task3
В скрипте добавлен ряд обработчиков сигналов.
Инструкция по запуску:
```
python fork.py
```
Во время исполнеия такие сигналы, как SIGINT (Ctrl+c) будут обработаны соответствующим образом.
# Task4 - ionice script
Same as task5 sctipt but with `ionice` instead of `nice`
Enable `cfq` in order to get ionice working
# Task5 - nice script
This sctipt performs simple random data generation and compression with different nice level. run as sudo since `nice` requres root permissions
No options are available
Log file is named nice.log
