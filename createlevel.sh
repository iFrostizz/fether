#/bin/sh

echo "Enter the level name"

read level

while [ ${#level} -eq 0 ] 
do
  echo "Please provide a level name."
  read level
done

case ${level:0:1} in
  [A-Z])
    echo "Creating the level $level ..."
    # for (( i = 1; i < ${#level}; i++ )); do
      # case ${level:${#i}-1:${#i}} in
        # [a-z])
          # echo "nothing"
          # ;;
        # *)
          # echo "error"
          # exit &
      # esac
    # done
    mkdir src/${level}
    touch src/${level}/Level.sol
    mkdir test/${level}
    cp SampleTest test/${level}/${level}.t.sol
    echo "Everything has been set up!"
    ;;
  *)
    echo "Level name must start with an uppercase. Aborting."
    exit 1
esac
