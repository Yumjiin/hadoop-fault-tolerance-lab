#!/bin/bash
# access.log를 한 줄씩 받아서 HTTP 상태 코드를 뽑아내고
# (상태코드 TAB 1) 형태로 출력한다.
# 예: 203.0.113.1 - - [31/Aug/2026:10:00:01 +0900] "GET / HTTP/1.1" 200 1043
#     -> 200<TAB>1

while IFS= read -r line; do
  status=$(echo "$line" | grep -oE '" [0-9]{3} ' | grep -oE '[0-9]{3}')
  if [ -n "$status" ]; then
    echo -e "${status}\t1"
  fi
done
