# Companies Marketplace

> Buy and sell items from your co-workers.

![coshop-cover](https://user-images.githubusercontent.com/15898299/92945344-87f56980-f42b-11ea-98f5-32767a20ddfb.jpg)

This project provides a marketplace for companies where all users registered with a company domain email can sell and buy things from other users of the same organization.

## Features

- Create posts to sell products / services
- Buy items from other users
- Messages between buyer/seller within an item order
- Notifications on orders status changes
- Users linked to their companies according to email domain
- Control post visibility
- Only users with profile info can buy and sell
- History of bought/sold items
- Responsive

## Built With

- Ruby 2.7.0
- Rails 6
- Devise (authentication)
- Rspec / Capybara (testing)
- TailwindCSS (styling)
- Rubocop (linter)

### Development Gems

  - bullet (improve db queries)
  - hirb (better visualization of query results in rails console)
  - rails-erd (generate entity relationship diagram)
  - guard-livereload (auto reloads page when saving file)

## Live Demo

- In progress

## Getting Started

### Prerequisites

- Ruby - To install it, check the [official page](https://www.ruby-lang.org/en/documentation/installation/).
- Rails - Check [this page](https://www.theodinproject.com/courses/ruby-on-rails/lessons/your-first-rails-application-ruby-on-rails) for more info.

### Setup

In terminal:
- Clone this repository: `$ git clone https://github.com/flpfar/companies-marketplace.git `
- Navigate to the project folder: `$ cd companies-marketplace `
- Run the following commands:
```
$ bundle install
$ rails db:create
$ rails db:migrate
```

**Sample data**

This project contains a seeds file to provide sample data for a preview of the application. The seeds file creates a company with domain 'coshop.com', some categories and posts. After running the seeds, it is possible to 'Sign up' users with emails like 'user@coshop.com'.

- In order to use the seeds file, run in terminal: `$ rails db:seed `

### Usage

- Create a company and a category for that company (each company has its own categories) through terminal: 
```
$ rails console
> Company.create(name: 'Company Name', domain: 'companydomain.com')
> Company.first.categories.create(name: 'Some category')
```

- Run `rails server` in terminal.
- Open a web browser and type ` http://localhost:3000/ ` on the address bar.
- Visit the 'Sign Up' page, create a user using a company's domain email and start playing around.

### Run tests

This project uses RSpec and Capybara for testing. In order to run the tests, type `rspec` in the terminal, inside this project folder. For more information about the running tests, use `rspec -f d`

## Development Notes

- I've been using a trello board to manage most of the tasks for this project. This board is available [here](https://trello.com/b/qaJ3KPx4/treinadev-marketplace).

- The Entity Relationship Diagram of this project is available [here](erd.pdf).

- This whole project has been developed following TDD (Test Driven Development) process.

## Potential Features

- Admin dashboard
- Wishlist
- Report posts

## 👤 Author

### Felipe Rosa (@flpfar)

[Github](https://github.com/flpfar) | [Twitter](https://twitter.com/flpfar) | [Linkedin](https://www.linkedin.com/in/felipe-augusto-rosa)

## Acknowledgements

- The requirements for this project were given by [Campus Code](https://www.campuscode.com.br/) as part of *TreinaDev* program.

## 🤝 Contributing

Contributions, issues and feature requests are welcome!

Feel free to check the [issues page](https://github.com/flpfar/world-data/issues).


## Show your support

Give a ⭐️ if you like this project!