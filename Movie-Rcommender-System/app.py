import streamlit as st
import pickle
import requests

movies=pickle.load(open("movies.pkl","rb"))  #movies acts as new_df
similarity=pickle.load(open("similarity.pkl","rb"))

def fetch_poster(movie_id):  #using movie_id we'll hit the api
    response=requests.get('https://api.themoviedb.org/3/movie/{}?api_key=37b55697c575a4da55dfd75c073e4e10&language=en-US'.format(movie_id))
    data=response.json()       #since the url gives a json file hence converting our response to a json file
    return "https://image.tmdb.org/t/p/w500/" + data['poster_path']
def recommend(movie):
    movie_index = movies[movies['title'] == movie].index[0]
    movies_list = sorted(list(enumerate(similarity[movie_index])), reverse=True, key=lambda x: x[1])[1:11]
    #we are getting our 10 movies in movies_list

    recommended_movie_names=[]
    recommended_movie_posters=[]

    for i in movies_list:
        movie_id=movies.iloc[i[0]].id

        recommended_movie_names.append((movies.iloc[i[0]].title))
        #fetch poster from api
        recommended_movie_posters.append(fetch_poster(movie_id))
    return recommended_movie_names,recommended_movie_posters



movie_list = movies['title'].values
selected_movie = st.selectbox(
    "Type or select a movie from the dropdown",
    movie_list
)


if st.button("Recommend"):
    recommended_movie_names, recommended_movie_posters = recommend(selected_movie)


col1,col2,col3,col4,col5,col6,col7,col8,col9,col10=st.columns(10)
with col1:
    st.text(recommended_movie_names[0])
    st.image(recommended_movie_posters[0])
with col2:
    st.text(recommended_movie_names[1])
    st.image(recommended_movie_posters[1])
with col3:
    st.text(recommended_movie_names[2])
    st.image(recommended_movie_posters[2])
with col4:
    st.text(recommended_movie_names[3])
    st.image(recommended_movie_posters[3])
with col5:
    st.text(recommended_movie_names[4])
    st.image(recommended_movie_posters[4])
with col1:
    st.text(recommended_movie_names[5])
    st.image(recommended_movie_posters[5])
with col2:
    st.text(recommended_movie_names[6])
    st.image(recommended_movie_posters[6])
with col3:
    st.text(recommended_movie_names[7])
    st.image(recommended_movie_posters[7])
with col4:
    st.text(recommended_movie_names[8])
    st.image(recommended_movie_posters[8])
with col5:
    st.text(recommended_movie_names[9])
    st.image(recommended_movie_posters[9])