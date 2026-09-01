#!/bin/bash
# Hadoop Streaming은 Shuffle 단계에서 key(상태코드) 기준으로 정렬해서 넘겨준다.
# 그래서 reducer는 "같은 key가 연속으로 들어온다"고 가정하고 순차 합산하면 된다.

current_key=""
count=0

while IFS=$'\t' read -r key value; do
  if [ "$key" == "$current_key" ]; then
    count=$((count + value))
  else
    if [ -n "$current_key" ]; then
      echo -e "${current_key}\t${count}"
    fi
    current_key="$key"
    count=$value
  fi
done

# 마지막 key 출력 (루프가 끝나면 마지막 그룹이 안 찍히므로 별도 처리)
if [ -n "$current_key" ]; then
  echo -e "${current_key}\t${count}"
fi
