#!/bin/bash

while true; do
    # Display the main menu and get user input
    choice=$(zenity --list \
    	--width=300 \
    	--height=350 \
        --title="Docker Operations by Zenity" \
        --column="Options" \
        "Containers" \
        "Images" \
        "Volumes" \
        "Networks" \
        "Exit")

    case $choice in
        "Containers")
            container_choice=$(zenity --list \
				--width=300 \
    			--height=350 \
                --title="Container Operations" \
                --column="Options" \
                "Run a Docker container" \
                "Stop a Docker container" \
                "Start a Docker container" \
                "Remove a Docker container" \
                "Exec into a Docker container" \
                "Inspect a Docker container")

            case $container_choice in
                "Run a Docker container")
                    # Ask the user for container details
                    name=$(zenity --entry --title="Run a Docker container" --text="Enter the name of the container:")
                    host_port=$(zenity --entry --title="Run a Docker container" --text="Enter the host port:")
                    container_port=$(zenity --entry --title="Run a Docker container" --text="Enter the container port:")
                    volume_path=$(zenity --entry --title="Run a Docker container" --text="Select the host volume path:")
                    container_volume_path=$(zenity --entry --title="Run a Docker container" --text="Select the host volume path:")
                    image_name=$(zenity --entry --title="Run a Docker container" --text="Enter the name of the Docker image:")
	
                    # Run the Docker container
                    docker run -d -it --name "$name" -p "$host_port:$container_port" -v "$volume_path:$container_volume_path" "$image_name"
                    ;;

                "Stop a Docker container")
                    # Get the list of running containers
                    running_containers=$(docker ps --format "{{.Names}}" | awk '{print $1 " "}')

                    # Ask the user to choose a container to stop
                    container_to_stop=$(zenity --list --title="Stop a Docker container" --column="Container" $running_containers)

                    # Stop the selected container
                    docker stop "$container_to_stop"
                    ;;

                "Remove a Docker container")
                    # Get the list of running containers
                    running_containers=$(docker ps -a --filter "status=exited" --format "{{.Names}}" | awk '{print $1 " "}')

                    # Ask the user to choose a container to remove
                    container_to_remove=$(zenity --list --title="Remove a Docker container" --column="Container" $running_containers)

                    # Remove the selected container
                    docker rm "$container_to_remove"
                    ;;

                "Exec into a Docker container")
                    # Get the list of running containers
                    running_containers=$(docker ps --format "{{.Names}}" | awk '{print $1 " "}')

                    # Ask the user to choose a container to exec into
                    container_to_exec=$(zenity --list --title="Exec into a Docker container" --column="Container" $running_containers)

                    # Ask the user for the command to execute inside the container
                    command=$(zenity --entry --title="Exec into a Docker container" --text="Enter the command to execute:")

                    # Exec into the selected container
                    docker exec -it "$container_to_exec" $command
                    ;;

                "Inspect a Docker container")
                    # Get the list of running containers
                    running_containers=$(docker ps --format "{{.Names}}" | awk '{print $1 " "}')

                    # Ask the user to choose a container to inspect
                    container_to_inspect=$(zenity --list --title="Inspect a Docker container" --column="Container" $running_containers)

                    # Inspect the selected container
                    docker inspect "$container_to_inspect" | less
                    ;;
                "Start a Docker container")
                	# Get the list of stopped containers
                	stopped_containers=$(docker ps -a --filter "status=exited" --format "{{.Names}}" | awk '{print $1 " "}')
                	
                	# Ask the user to choose a container to start
                	container_to_start=$(zenity --list --title="Start a Docker container" --column="Stopped Container" $stopped_containers)
                	
                	# Start the selected container
                	docker start "$container_to_start"
                	;;
            esac
            ;;

        "Images")
            image_choice=$(zenity --list \
				--width=300 \
    			--height=350 \
                --title="Image Operations" \
                --column="Options" \
                "List all images" \
                "Pull an image" \
                "Remove an image" \
                "Tag an image" \
                "Push an image" \
                "Inspect an image")

            case $image_choice in
                "List all images")
                    # List all Docker images
                    docker images | less
                    ;;

                "Pull an image")
                    # Ask the user for the image name to pull
                    image_name=$(zenity --entry --title="Pull an image" --text="Enter the name of the image to pull:")

                    # Pull the specified image
                    docker pull "$image_name"
                    ;;

                "Remove an image")
                    # Get the list of images
                    images=$(docker images --format "{{.Repository}}:{{.Tag}}")

                    # Ask the user to choose an image to remove
                    image_to_remove=$(zenity --list --title="Remove an image" --column="Image" $images)

                    # Remove the selected image
                    docker rmi "$image_to_remove"
                    ;;
            	"Tag an image")
		            # Ask the user for the image name to tag
		            image_name=$(zenity --entry --title="Tag an image" --text="Enter the name of the image to Tag:")
		            new_image_name=$(zenity --entry --title="Tag an image" --text="Enter the name of the new image to Tag:\nRegistryName/RepositoryName:ImageTag")

		            # Inspect the specified image
		            docker tag "$image_name" "$new_image_name"
		            ;;
                "Push an image")
                	username=$(zenity --entry --title="Repository Username" --text="Enter the Username of the repository:")
                    password=$(zenity --entry --title="Repository Password" --text="Enter the Password of the repository:")
                	
                	docker login -u $username -p $password 2> /dev/null
                	
                	if [ $? -eq 0 ]; then
                		zenity --info --title "Success" --text "Logged In successfully!"
                	else
                		zenity --error --title "Error" --text "Failed to Login."
					fi
                	
                    # Ask the user for the image name and destination
                    # image_name=$(zenity --entry --title="Push an image" --text="Enter the name of the image to push:")
                    # destination=$(zenity --entry --title="Push an image" --text="Enter the destination repository:")
					tag_image_name=$(zenity --entry --title="Tag an image" --text="Enter the name of the new image to Push:\nRegistryName/RepositoryName:ImageTag")
                    # Push the specified image
                    docker push "$tag_image_name"
                    
                    docker logout
                    ;;

                "Inspect an image")
                    # Get the list of images
                    images=$(docker images --format "{{.Repository}}:{{.Tag}}")

                    # Ask the user to choose an image to inspect
                    image_to_inspect=$(zenity --list --title="Remove an image" --column="Image" $images)

                    # Inspect the specified image
                    docker inspect "$image_to_inspect" | less
                    ;;
            esac
            ;;

        "Volumes")
            volume_choice=$(zenity --list \
            	--width=300 \
    			--height=350 \
                --title="Volume Operations" \
                --column="Options" \
                "Create a volume" \
                "List all volumes" \
                "Remove a volume" \
                "Inspect a volume")

            case $volume_choice in
                "Create a volume")
                    # Ask the user to choose between Named Volume and Managed Volume
                    volume_type=$(zenity --list --title="Create a volume" --column="Type" "Named Volume" "Managed Volume")

                    if [ "$volume_type" == "Named Volume" ]; then
                        # Ask the user for the volume name
                        volume_name=$(zenity --entry --title="Create a volume" --text="Enter the name of the volume:")

                        # Create a named volume
                        docker volume create "$volume_name"
                    elif [ "$volume_type" == "Managed Volume" ]; then
                        # Ask the user for the volume name and path
                        volume_name=$(zenity --entry --title="Create a volume" --text="Enter the name of the volume:")
                        volume_path=$(zenity --file-selection --directory --title="Create a volume" --text="Select the volume path:")

                        # Create a managed volume
                        docker volume create --driver local --opt type=none --opt o=bind --opt device="$volume_path" "$volume_name"
                    fi
                    ;;

                "List all volumes")
                    # List all Docker volumes
                    docker volume ls | less
                    ;;

                "Remove a volume")
                    # Get the list of volumes
                    volumes=$(docker volume ls --format "{{.Name}}")

                    # Ask the user to choose a volume to remove
                    volume_to_remove=$(zenity --list --title="Remove a volume" --column="Volume" $volumes)

                    # Remove the selected volume
                    docker volume rm "$volume_to_remove"
                    ;;

                "Inspect a volume")
                    # Get the list of volumes
                    volumes=$(docker volume ls --format "{{.Name}}")

                    # Ask the user to choose a volume to inspect
                    volume_to_inspect=$(zenity --list --title="Inspect a volume" --column="Volume" $volumes)

                    # Inspect the selected volume
                    docker volume inspect "$volume_to_inspect" | less
                    ;;
            esac
            ;;

        "Networks")
            network_choice=$(zenity --list \
            	--width=300 \
    			--height=350 \
                --title="Network Operations" \
                --column="Options" \
                "Create a network" \
                "List all networks" \
                "Remove a network" \
                "Inspect a network")

            case $network_choice in
                "Create a network")
                    # Ask the user to choose between Default Network and Custom Network
                    network_type=$(zenity --list --title="Create a volume" --column="Type" "Default Network" "Custom Network")

                    if [ "$network_type" == "Default Network" ]; then
                        # Ask the user for the volume name
                        network_name=$(zenity --entry --title="Create a Default network" --text="Enter the name of the network:")

                        # Create a default network
                        docker network create "$network_name"
                    elif [ "$network_type" == "Custom Network" ]; then
                        # Ask the user for the network name and subnet
                        network_name=$(zenity --entry --title="Create a custom network" --text="Enter the name of the network:")
                        network_subnet=$(zenity --entry --title="Create a custom network" --text="Enter the subnet value of network:")

                        # Create a managed network
                        docker network create --subnet "$network_subnet" "$network_name"
                    fi
                    ;;

                "List all networks")
                    # List all Docker networks
                    docker network ls | less
                    ;;

                "Remove a network")
                    # Get the list of network
                    networks=$(docker network ls --format "{{.Name}}")

                    # Ask the user to choose a volume to remove
                    network_to_remove=$(zenity --list --title="Remove a network" --column="Network" $networks)

                    # Remove the selected volume
                    docker network rm "$network_to_remove"
                    ;;

                "Inspect a network")
                    # Get the list of networks
                    networks=$(docker network ls --format "{{.Name}}")

                    # Ask the user to choose a volume to inspect
                    network_to_inspect=$(zenity --list --title="Inspect a network" --column="network" $networks)

                    # Inspect the selected volume
                    docker network inspect "$network_to_inspect" | less
                    ;;
            esac
            ;;
        "Exit")
            # Exit the loop and end the script
            break
            ;;
    esac
done

