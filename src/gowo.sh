#!/bin/bash

api="https://gowo.su/api"
node_api="https://sports-gowo-su.cf:8443"
token=null
user_id=null

function login() {
	# 1 - login: (string): <email, phone number>
	# 2 - password: (string): <password>
	response=$(curl --request POST \
		--url "$api/token" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--data '{
			"login": "'$1'",
			"password": "'$2'"
		}')
	if [ -n $(jq -r ".data.token" <<< "$response") ]; then
		token=$(jq -r ".data.token" <<< "$response")
		user_id=$(jq -r ".id" <<< "$(get_account_info)")
	fi
	echo $response
}

function register() {
	# 1 - name: (string): <name>
	# 2 - surname: (string): <surname>
	# 3 - birthday: (string): <birthday> -> 0000-00-00T16:00:00.000Z
	# 4 - gender: (integer): <female - 1, male - 2>
	# 5 - email: (string): <email>
	# 6 - password: (string): <password>
	curl --request POST \
		--url "$api/registration" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--data '{
			"name": "'$1'",
			"surname": "'$2'",
			"birthday": "'$3'",
			"gender": "'$4'",
			"email": "'$5'",
			"password": "'$6'",
		}'
}

function get_account_info() {
	curl --request GET \
		--url "$api/current" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $token"
}

function get_menu_data() {
	curl --request GET \
		--url "$api/menu-data" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json"
}

function get_vip_users() {
	curl --request GET \
		--url "$api/vip-users" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json"
}

function get_new_films() {
	curl --request GET \
		--url "$api/new-films" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json"
}

function get_last_comments() {
	curl --request GET \
		--url "$api/last-comments-films" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json"
}

function get_active_rooms() {
	# 1 - limit: (integer): <limit - default: 10>
	# 2 - start: (integer): <start - default: 0>
	curl --request GET \
		--url "$api/active-rooms?limit=${1:-10}&start=${2:-0}" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json"
}

function get_last_users() {
	curl --request GET \
		--url "$api/last-users" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json"
}

function get_posts_users() {
	# 1 - limit: (integer): <limit - default: 20>
	# 2 - start: (integer): <start - default: 0>
	curl --request GET \
		--url "$api/posts-users?limit=${1:-20}&start=${2:-0}" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json"
}

function emote_to_post() {
	# 1 - post_id: (integer): <post_id>
	# 2 - smile: (string): <smile>
	curl --request POST \
		--url "$api/emotions" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $token" \
		--data '{
			"post_id": "'$1'",
			"smile": "'$2'"
		}'
}

function get_user_info() {
	# 1 - user_id: (integer): <user_id>
	curl --request GET \
		--url "$api/user/$1" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json"
}

function get_user_posts() {
	# 1 - user_id: (integer): <user_id>
	curl --request GET \
		--url "$api/user/posts/$1" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json"
}

function follow_user() {
	# 1 - user_id: (integer): <user_id>
	curl --request POST \
		--url "$api/user/follow/$1" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $token"
}

function unfollow_user() {
	# 1 - user_id: (integer): <user_id>
	curl --request POST \
		--url "$api/user/unfollow/$1" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $token"
}

function comment_post() {
	# 1 - message: (string): <message>
	# 2 - id: (integer): <post_id>
	curl --request POST \
		--url "$api/user/comment/create" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $token" \
		--data '{
			"message": "'$1'",
			"action": "comment",
			"id": "'$2'"
		}'
}

function get_dialogs() {
	curl --request GET \
		--url "$api/dialogs" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $token"
}

function get_notifications() {
	curl --request GET \
		--url "$api/notifications" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $token"
}

function get_films_recommendation() {
	curl --request GET \
		--url "$api/films/recommendation" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json"
}

function send_dialog_message() {
	# 1 - to: (integer): <user_id>
	# 2 - message: (string): <message>
	curl --request POST \
		--url "$api/message" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $token" \
		--data '{
			"to": "'$1'",
			"message": "'$2'"
		}'
}

function search() {
	# 1 - query: (string): <query>
	# 2 - start: (integer): <start - default: 0>
	# 3 - limit: (integer): <limit - default: 20>
	# 4 - target: (string): <target>
	curl --request GET \
		--url "$api/find?s=$1&start=${2:-0}&limit=${3:-20}&target=$4" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json"
}

function get_movie_filters() {
	curl --request GET \
		--url "$api/params-filter-movies" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json"
}

function get_novelties() {
	curl --request GET \
		--url "$api/user/widget/novelties" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $token"
}

function edit_profile() {
	# 1 - name: (string): <name>
	# 2 - surname: (string): <surname>
	# 3 - country: (string | integer): <country, country_id>
	# 4 - city: (string): <city - default: null>
	# 5 - birthday: (string): <birthday> -> 0000-00-00
	# 6 - gender: (integer): <female - 1, male - 2>
	# 7 - facebook: (string): <facebook - default: null>
	# 8 - youtube: (string): <youtube - default: null>
	# 9 - vk: (string): <vk - default: null>
	# 10 - instagram: (string): <instagram - default: null>
	# 11 - tiktok: (string): <tiktok - default: null>
	account_info=$(get_account_info)
	birthday=$(jq -r ".birthday" <<< "$account_info")
	curl --request POST \
		--url "$api/settings" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $token" \
		--data '{
			"name": "'${1:-$(jq -r ".name" <<< "$account_info")}'",
			"surname": "'${2:-$(jq -r ".surname" <<< "$account_info")}'",
			"country": "'${3:-undefined}'",
			"city": '${4:-null}',
			"birthday": "'${5:-${birthday:0:10}}'",
			"gender": "'${6:-$(jq -r ".gender" <<< "$account_info")}'",
			"facebook": '${7:-null}',
			"youtube": '${8:-null}',
			"vk": '${9:-null}',
			"instagram": '${10:-null}',
			"tiktok": '${11:-null}'
		}'
}

function get_user_followers() {
	# 1 - user_id: (integer): <user_id>
	# 2 - start: (integer): <start - default: 0>
	# 3 - limit: (integer): <limit - default: 20>
	curl --request GET \
		--url "$api/user/followers/$1?start=${2:-0}&limit=${3:-20}" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json"
}

function get_user_followings() {
	# 1 - user_id: (integer): <user_id>
	# 2 - start: (integer): <start - default: 0>
	# 3 - limit: (integer): <limit - default: 20>
	curl --request GET \
		--url "$api/user/following/$1?start=${2:-0}&limit=${3:-20}" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json"
}

function get_user_gifts() {
	# 1 - user_id: (integer): <user_id>
	curl --request GET \
		--url "$api/user/gifts/$1" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json"
}

function user_global_search() {
	# 1 - id: (integer): <user_id>
	# 2 - query: (string): <query>
	# 3 - start: (integer): <start - default: 0>
	# 4 - limit: (integer): <limit - default: 20>
	curl --request POST \
		--url "$api/user/global-search" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--data '{
			"id": "'$1'",
			"s": "'$2'".
			"start": "'${3:-0}'",
			"limit": "'${4:-20}'"
		}'
}

function get_bookmarks() {
	# 1 - start: (integer): <start - default: 0>
	# 2 - limit: (integer): <limit - default: 20>
	curl --request GET \
		--url "$api/bookmarks/get?start=${1:-0}&limit=${2:-20}" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $token"
}

function create_post() {
	# 1 - message: (string): <message>
	curl --request POST \
		--url "$api/user/posts/create" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $token" \
		--data '{
			"message": "'$1'"
		}'
}

function delete_post() {
	# 1 - id: (integer): <post_id>
	curl --request POST \
		--url "$api/user/posts/delete" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $token" \
		--data '{
			"id": "'$1'"
		}'
}

function get_film_info() {
	# 1 - film_id: (integer): <film_id>
	curl --request GET \
		--url "$api/movie?id=$1" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json"
}

function get_film_casts() {
	# 1 - film_id: (integer): <film_id>
	curl --request POST \
		--url "$api/get-film-casts" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--data '{
			"idFilm": "'$1'"
		}'
}

function get_film_comments() {
	# 1 - film_id: (integer): <film_id>
	curl --request POST \
		--url "$api/comments-film" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--data '{
			"id": "'$1'"
		}'
}


function get_similar_films() {
	# 1 - film_id: (integer): <film_id>
	curl --request POST \
		--url "$api/similar" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--data '{
			"id": "'$1'"
		}'
}

function create_room() {
	# 1 - access: (integer): <closed - 1, public - 2>
	# 2 - id: (integer): <film_id>
	curl --request POST \
		--url "$api/room/create" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $token" \
		--data '{
			"access": "'$1'",
			"idFilm": "'$2'"
		}'
}

function close_room() {
	# 1 - room_id: (string): <room_id>
	curl --request POST \
		--url "$api/similar" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $token" \
		--data '{
			"room": "'$1'"
		}'
}

function get_room_info() {
	# 1 - room_id: (string): <room_id>
	curl --request POST \
		--url "$api/close-room" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--data '{
			"room": "'$1'"
		}'
}

function join_room() {
	# 1 - room_id: (string): <room_id>
	curl --request POST \
		--url "$node_api/room/join" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $token" \
		--data '{
			"room": "'$1'"
		}'
}

function send_room_message() {
	# 1 - room_id: (string): <room_id>
	# 2 - message: (string): <message>
	curl --request POST \
		--url "$node_api/room/message" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $token" \
		--data '{
			"room": "'$1'",
			"message": "'$2'"
		}'
}

function leave_room() {
	# 1 - room_id: (string): <room_id>
	curl --request POST \
		--url "$node_api/room/disconnect" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $token" \
		--data '{
			"room": "'$1'"
		}'
}

function get_opened_rooms() {
	curl --request GET \
		--url "$api/opened-rooms" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $token"
}

function change_password() {
	# 1 - old_password: (string): <old_password>
	# 2 - new_password: (string): <new_password>
	curl --request POST \
		--url "$api/change-password" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $token" \
		--data '{
			"oldPassword": "'$1'",
			"password": "'$2'",
			"confirmPassword": "'$2'"
		}'
}

function delete_account() {
	curl --request DELETE \
		--url "$api/delete-account" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $token"
}

function recover_account() {
	# 1 - token: (string): <token>
	curl --request POST \
		--url "$api/recover-account" \
		--user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36" \
		--header "accept: application/json" \
		--header "content-type: application/json" \
		--header "authorization: Bearer $1"
}
