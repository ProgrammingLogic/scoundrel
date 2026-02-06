find ./images -name "card_*.png" ! -name "card_back.png" ! -name "card_empty.png" | while read -r file; do
    # Get the filename without path or extension (e.g., card_clubs_02)
    base=$(basename "$file" .png)
    
    # Split the name into parts using underscore as delimiter
    # card_clubs_02 -> suit_plural=clubs, value=02
    IFS='_' read -r _ suit_plural value <<< "$base"
    
    # Strip the 's' from the suit (clubs -> club)
    suit="${suit_plural%s}"
    
    # Remove leading zero from value (02 -> 2), but keep A, J, Q, K
    clean_value="${value#0}"
    
    # Determine color based on suit
    if [[ "$suit" == "club" || "$suit" == "spade" ]]; then
        color="black"
    else
        color="red"
    fi

    # Handle Jokers specifically if they exist
    if [[ "$suit" == "joker" ]]; then
        name="joker_${value}"
        color="${value}" # black or red
    else
        name="${suit}_${clean_value}"
    fi

    # Create the JSON file in the ./data directory
    cat <<EOF > "./data/${base}.json"
{
    "name": "${name}",
    "front_image": "${base}.png",
    "suit": "${suit}",
    "value": "${clean_value}",
    "color": "${color}"
}
EOF
done
