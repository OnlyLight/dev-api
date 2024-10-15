#!/bin/bash

# Get the list of paths being monitored
monitored_paths_be=$(echo "${PATH_SERVICES_BE}" | tr "," " ")

echo "Monitored paths be: $monitored_paths_be"

list_services_be=()

for path in $monitored_paths_be
do
  for file in ${ALL_CHANGED_FILES}; do
    # Check if the modified files include this path
    if echo "$file" | cut -c 1-50| grep "$path" ; then #get 50 letters
      # Set the output variable and exit the loop
      echo "triggering_path is $path"
      list_services_be+=($path)
      break
    fi
  done
done

bash_array_to_json() {
  local -n arr=$1  # Create a nameref to the input array
  local json_array="["
  
  if [ ${#arr[@]} -gt 0 ]; then
    for item in "${arr[@]}"; do
      json_array+="\"$item\", "
    done
    json_array="${json_array%, }"  # Remove the trailing comma
  fi

  json_array+="]"
  echo "$json_array"
}

echo "array BE $list_services_be"
echo "BE $(bash_array_to_json list_services_be)"

echo "be_triggering_path=$(bash_array_to_json list_services_be)" >> $GITHUB_OUTPUT
