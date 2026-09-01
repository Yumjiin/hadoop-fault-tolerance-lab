#!/bin/bash
# 사용법: run-status-count.sh <실행이름>
# 예: run-status-count.sh before   -> /output/status-before 에 저장
#     run-status-count.sh after    -> /output/status-after 에 저장

RUN_NAME=$1
if [ -z "$RUN_NAME" ]; then
  echo "사용법: run-status-count.sh <실행이름>"
  exit 1
fi

# 같은 경로로 재실행하면 Hadoop이 에러를 내므로 기존 출력 삭제
hdfs dfs -rm -r -f /output/status-${RUN_NAME}

# NOTE: jar 경로는 이미지 버전에 따라 다를 수 있음.
# 컨테이너 안에서 아래 명령으로 먼저 실제 경로를 확인할 것:
#   docker exec resourcemanager find / -name "hadoop-streaming*.jar" 2>/dev/null
hadoop jar /opt/hadoop-3.2.1/share/hadoop/tools/lib/hadoop-streaming-3.2.1.jar \
  -D mapreduce.job.reduces=1 \
  -files /opt/lab/mapper.sh,/opt/lab/reducer.sh \
  -input /input/logs/access.log \
  -output /output/status-${RUN_NAME} \
  -mapper "bash mapper.sh" \
  -reducer "bash reducer.sh"
