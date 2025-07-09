#
# Executes commands at logout.
#
# Execute code only if STDERR is bound to a TTY.
[[ -o INTERACTIVE && -t 2 ]] && {

SAYINGS=(
    "So long and thanks for all the fish.\n  -- Douglas Adams"
    "Good morning! And in case I don't see ya, good afternoon, good evening and goodnight.\n  --Truman Burbank"
    "They must often change, who would be constant in happiness or wisdom.\n  --Confucius"
    "Every new beginning comes from some other beginning’s end.\n  --Semisonic"
    "Farewell! God knows when we shall meet again.\n  --William Shakespeare"
    "It is so hard to leave—until you leave. And then it is the easiest thing in the world.\n  --John Green"
    "If you’re brave enough to say goodbye, life will reward you with a new hello.\n  --Paulo Coelho"
    "Goodbyes make you think. They make you realize what you’ve had, what you’ve lost, and what you’ve taken for granted.\n  --Ritu Ghatourey"
    "It’s sad, but sometimes moving on with the rest of your life, starts with goodbye.\n  --Carrie Underwood"
    "Don’t cry because it’s over. Smile because it happened.\n  --Dr. Seuss"
    "Goodbyes, they often come in waves.\n  --Jarod Kintz"
    "Goodbye always makes my throat hurt.\n  --Charlie Brown"
)

# Print a randomly-chosen message:
echo $SAYINGS[$(($RANDOM % ${#SAYINGS} + 1))]

} >&2

