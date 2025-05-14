### Basic project for Yahoo
- No libraries used
- Should run on any ios 16+ simulator

#### App is a stock ticker app
- App should show list of companies. Pagination on API is not implemented so app will show all results for now but pagination is stubbed out
- User can change the sort order of the companies list
- User can tap a company to view details like Market Cap and Favorite the company
- Searching is available but done in memory. If pagination is available on the api, then searching would need to be done on the api level


#### Future considerations
- Loading spinners for initial api fetch
- Error handling for if the api fails
- Infinite scroll or pagination for over 100 companies
- Fetch company logos from web and populate the placeholders
