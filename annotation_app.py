import streamlit as st 
import numpy as np 
import pandas as pd 
import matplotlib.pyplot as plt 
from Page_One import Page_one
from Page_Two import Page_two
import streamlit 


PAGES = {
    "Annotation ! " : 1,
    "Classes" : 2
    
}

st.sidebar.title("Navigation")
selection = st.sidebar.radio("Go to", list(PAGES.keys()))
val=False

page = PAGES[selection]

if page == 2 :
    first_page = Page_one()
    first_page.show_classes()

elif page == 1 :
    second_page = Page_two()
    val = second_page.main()


    
