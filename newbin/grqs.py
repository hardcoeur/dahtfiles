import requests
from bs4 import BeautifulSoup

def get_quotes(author_name, page_number):
    url = f'https://www.goodreads.com/quotes/search?page={page_number}&utf8=%E2%9C%93&q={author_name}&commit=Search'
    headers = {
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Safari/605.1.15'
    }
    response = requests.get(url, headers=headers)
    soup = BeautifulSoup(response.content, 'html.parser')
    return soup.find_all('div', {'class': 'quoteText'})

def has_next_page(soup):
    next_link = soup.find('a', {'class': 'next_page'})
    return next_link is not None

def split_lines(text, max_line_length):
    words = text.split()
    lines = []
    current_line = []

    for word in words:
        if len(' '.join(current_line + [word])) <= max_line_length:
            current_line.append(word)
        else:
            lines.append(' '.join(current_line))
            current_line = [word]

    lines.append(' '.join(current_line))
    return '\n'.join(lines)

author_name = 'Yoko Ogawa'
page_number = 1
output_file = 'quotes_fortune.txt'

try:
    with open(output_file, 'a') as f:
        while True:
            quotes = get_quotes(author_name, page_number)

            if not quotes:
                break

            for quote in quotes:
                quote_text = quote.get_text(strip=True).split('―')[0].strip()
                if len(quote_text) <= 500:
                    formatted_quote = split_lines(quote_text, 87)
                    f.write(f'"{formatted_quote}" --{author_name}\n%\n')

            headers = {
                'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Safari/605.1.15'
            }
            soup = BeautifulSoup(requests.get(f'https://www.goodreads.com/quotes/search?page={page_number}&utf8=%E2%9C%93&q={author_name}&commit=Search', headers=headers).content, 'html.parser')
            
            if not has_next_page(soup):
                break

            page_number += 1
except KeyboardInterrupt:
    print("\nInterrupted by user. Exiting gracefully...")

