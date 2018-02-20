# README

This small app was built to handle one POST request to /celeb_birthdays

The POST request needs to have two parameters: {month: int, date: int}

The months start at 1 (January) and go to 12.  The date starts at 1 and goes to the end of the given month.

The route will return an object that looks like this:

```
{
  people: [
    {
     name: "Gemma Arterton",
     photoUrl: "https://images-na.ssl-images-amazon.com/images/M/MV5BOTAwNTMwMzE5OF5BMl5BanBnXkFtZTgwMjYwNzI2MjE@._V1_UX140_CR0,0,140,209_AL_.jpg",
     profileUrl: "http://www.imdb.com/name/nm2605345",
     mostKnownWork: {
        title: "Prince of Persia: The Sands of Time",
        url: "http://www.imdb.com/title/tt0473075/",
        rating: 6.6,
        director: "Louis Leterrier"
     }
    },
    ...
  ]
}
```
