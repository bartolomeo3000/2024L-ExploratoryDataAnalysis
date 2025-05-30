library(dplyr)

data <- read.csv("data.csv")


# Zadanie 0 ---------------------------------------------------------------
# Jaka marka samochodu najczesciej wystepuje w zbiorze danych?

data %>%
  group_by(Make) %>%
  summarise(n = n()) %>%
  arrange(-n)

# Odp.: Chevrolet   


# Zadanie 1 ---------------------------------------------------------------
# Jaka jest mediana mocy silnika dla samochodów w zależności od rodzaju
# skrzyni biegów?

data %>% 
  group_by(Transmission.Type) %>% 
  summarise(median = median(Engine.HP, na.rm = TRUE))

# Odp.: AUTOMATED_MANUAL: 220 KM
#       AUTOMATIC       : 253 KM
#       DIRECT_DRIVE    : 147 KM
#       MANUAL          : 172 KM
#       UNKNOWN         : 125 KM


# Zadanie 2 ---------------------------------------------------------------
# Jaki jest rozstęp międzykwartylowy spalania w mieście samochodów Mercedes-Benz,
# które korzystają z oleju napędowego (diesel)?

data %>% 
  filter(Make == "Mercedes-Benz", Engine.Fuel.Type == "diesel") %>% 
  summarise(iqr = IQR(city.mpg, na.rm = TRUE))

# Odp.: 7.25


# Zadanie 3 ---------------------------------------------------------------
# Biorąc pod uwagę samochody z 4 cylindrowymi silnikami, który producent
# podaje najwyższą średnią sugerowaną cenę detaliczną? Ile wynosi ta cena?

data %>% 
  filter(Engine.Cylinders == 4) %>% 
  group_by(Make) %>% 
  summarise(mean = mean(MSRP, na.rm = TRUE)) %>% 
  arrange(-mean) %>% 
  head(1)

# Odp.: Alfa Romeo, 61 600


# Zadanie 4 ---------------------------------------------------------------
# Czy więcej jest Aut BMW z napędem na przód, na tył czy z napędem na 4 koła?
# Podaj najczęściej występujący model dla tego rodzaju napędu.
  
data %>% 
  filter(Make == "BMW") %>% 
  group_by(Driven_Wheels) %>% 
  summarise(n = n()) %>% 
  arrange(-n)

data %>% 
  filter(Make == "BMW", Driven_Wheels == "rear wheel drive") %>% 
  group_by(Model) %>% 
  summarise(n = n()) %>% 
  arrange(-n)

# Odp.: Najwięcej jest aut z napędem na tył, następne na 4 koła, a najmniej na przód.
#       Dla napędu na tylnie koła najczęśtszy model to 1 Series


# Zadanie 5 ---------------------------------------------------------------
# Jak zmienia się mediana mocy silnika w zależności od tego czy samochód posiada
# 2 lub 4 drzwi dla marki Volkswagen?

data %>% 
  filter(Make == "Volkswagen") %>% 
  group_by(Number.of.Doors) %>% 
  summarise(median = median(Engine.HP, na.rm = TRUE)) %>% 
  arrange(Number.of.Doors)

# Odp.: Dla 2-drzwiowych mediana wynosi 170, dla 4-drzwiowych wynosi 200
#       Dla 4-drzwiowych jest większa o 30 KM


# Zadanie 6 ---------------------------------------------------------------
# Samochody, z którego roku i jakiej marki mają największe średnie spalanie 
# w mieście? Ile wynosi to spalanie? Wynik podaj w L/100km.

galon_litr = 3.7853
mila_km = 1.6093

data %>% 
  group_by(Year, Make) %>% 
  summarize(mean = mean(city.mpg, na.rm = TRUE)) %>%
  mutate(L_100KM = (100 * galon_litr) / (mila_km * mean)) %>% 
  arrange(-L_100KM) %>% 
  select(Year, Make, L_100KM) 

# Odp.: Bugatti z 2008 i 2009 roku, 29.4 L/100km


# Zadanie 7 ---------------------------------------------------------------
# Grupując po roku, w latach 2007-2017 jaki styl samochodów był średnio najbardziej popularny?
# Jaki styl najczęściej wystąpił jako średnio najbardziej popularny przez te 10 lat?
  
most_popular_styles <- data %>%
  filter(Year >= 2007 & Year <= 2017) %>%
  group_by(Year, Vehicle.Style) %>%
  summarize(Avg_Popularity = mean(Popularity, na.rm = TRUE)) %>%
  group_by(Year) %>%
  filter(Avg_Popularity == max(Avg_Popularity))

most_popular_styles_summary <- most_popular_styles %>%
  group_by(Vehicle.Style) %>% 
  count() %>%
  arrange(desc(n))

most_popular_styles
most_popular_styles_summary

# Odp.:   2007 Cargo Minivan                 
#         2008 Crew Cab Pickup               
#         2009 Extended Cab Pickup           
#         2010 Extended Cab Pickup            
#         2011 Regular Cab Pickup             
#         2012 Passenger Van                  
#         2013 Cargo Van                      
#         2013 Passenger Van                  
#         2014 Cargo Van                     
#         2015 Cargo Minivan                  
#         2016 Cargo Minivan                 
#         2017 Passenger Van   

# Uwaga: W 2013 Cargo Van i Passenger Van były obydwa średnio najbardziej popularne

# Najczęściej (3 razy) pojawiły się: Cargo Minivan, Cargo Van, Passenger Van


# Zadanie 8 ---------------------------------------------------------------
# Jakiej marki samochody mają najwyższą medianę sugerowanej ceny w kategorii "Luxury,Performance"
# i są wyprodukowane po 2000 roku wliczając ten rok? Jak różni się średnia liczba cylindrów i mocy
# silnika marki z najwyższą i najniższą medianą sugerowanej ceny detalicznej w tej kategorii?


result_8 <- data %>% 
  filter(Market.Category == "Luxury,Performance", Year >= 2000) %>% 
  group_by(Make) %>% 
  summarise(median_msrp = median(MSRP, na.rm = TRUE),
            mean_cyl = mean(Engine.Cylinders, na.rm = TRUE),
            mean_hp = mean(Engine.HP, na.rm = TRUE))

result_8 %>% 
  arrange(median_msrp) %>% 
  head(1)

result_8 %>% 
  arrange(-median_msrp) %>% 
  head(1)

i_8 <- 6/10.7
j_8 <- 311/397


# Odp.: Volkswagen ma najwyzsza mediane sugerowanej ceny
#       Między markami  najmniejszej medianie sugerowanej ceny wzgledem największej:
#       Średnia liczba cylindrów najmniejszej mediany stanowi 0.5607 średniej liczby cylindrow dla największej mediany
#       Średnia liczba konii mechanicznych najmniejszej mediany stanowi 0.7833 średniej liczby konii mechanicznych dla największej mediany


# Zadanie 9 ---------------------------------------------------------------
# Ile wynosi 0.1 i 0.9 kwantyl spalania w mieście dla samochodów
# z automatyczną skrzynią biegów i rozmiarze "Midsize"?

data %>% 
  filter(Transmission.Type == "AUTOMATIC", Vehicle.Size == "Midsize") %>% 
  summarise(q01 = quantile(city.mpg, probs = 0.1, na.rm = TRUE),
            q09 = quantile(city.mpg, probs = 0.9, na.rm = TRUE))

# Odp.: Kwantyl 0.1 wynosi 14, kwantyl 0.9 wynosi 25


# Zadanie 10 --------------------------------------------------------------
# Jaki jest drugi najbardziej popularny model marki Porsche,
# który posiada nie więcej niż 300 koni mechanicznych?

data %>% 
  filter(Make == "Porsche", Engine.HP <= 300) %>% 
  arrange(-Popularity) %>% 
  select(Model, Popularity) %>% 
  top_n(2)

data %>% 
  filter(Make == "Porsche", Engine.HP <= 300) %>% 
  group_by(Popularity) %>% 
  summarise(n = n())

data %>% 
  filter(Make == "Porsche", Engine.HP <= 300) %>% 
  group_by(Model) %>% 
  summarise(n = n()) %>% 
  arrange(-n) %>% 
  top_n(2)
  

# Odp.: Nie ma drugiego najbardziej popularnego modelu. Wszystkie modele mają taką samą popularność 1715
#       Jeżeli popularność mierzymy w ilościach takich samochodów, to drugi najpopularnieszy model to ex aequo 944 i Cayenne

# Zadanie 11 --------------------------------------------------------------
# Dla jakiej kombinacji typu paliwa i rodzaju napędu mediana koni mechanicznych jest największa?
# Ile wynosi średnie spalanie na autostradzie dla tej kombinacji w L/100?

galon_litr = 3.7853
mila_km = 1.6093

data %>% 
  mutate(L_100KM = (100 * galon_litr) / (mila_km * highway.MPG)) %>% 
  group_by(Engine.Fuel.Type, Driven_Wheels) %>% 
  summarise(median_hp = median(Engine.HP, na.rm = TRUE),
            mean_L_100KM = mean(L_100KM, na.rm = TRUE)) %>%
  arrange(-median_hp) %>% 
  head(1)
  
# Odp.: Dla kombinacji: flex-fuel (premium unleaded required/E85), all wheel drive
#       Średnie spalanie na autostradzie wynoi 12.3 L/100KM


# Zadanie 12 --------------------------------------------------------------
# Jaka kombinacja marki i modelu samochodu ma największą średnią różnicę
# spalania w mieście i na autostradzie w L/100? Ile wynosi ta różnica?

data %>% 
  mutate(HW_L_100KM = (100 * galon_litr) / (mila_km * highway.MPG),
         City_L_100KM = (100 * galon_litr) / (mila_km * city.mpg),
         diff = City_L_100KM - HW_L_100KM) %>% 
  group_by(Make, Model) %>% 
  summarise(mean_diff = mean(diff, na.rm = TRUE)) %>% 
  arrange(-mean_diff) %>% 
  head(1)


# Odp.: Ferrari Enzo, roznica wynosi 14