library lexer;

import 'package:monkey/token/token.dart';

class Lexer {

    // Code points for whitespace characters
    static final int space    = code(' ');
    static final int tab      = code('\t');
    static final int newline  = code('\n');
    static final int carriage = code('\r');

    // Code points for numeric characters
    static final int zero     = code('0');
    static final int nine     = code('9');

    // Code points for alpha characters and _
    static final int a = code('a');
    static final int z = code('z');
    static final int A = code('A');
    static final int Z = code('Z');
    static final int _ = code('_');

    // Code point for null character \0
    static final int nil = code('␀');

    String input;

    // current position in input (points to current char)
    int position = 0;

    // current reading position in input (after current char)
    int readPosition = 0;

    // current char under examination
    String ch;

    Lexer(this.input) {

        readChar();

    }

    void readChar() {

        if (readPosition >= input.length) {
            ch = '␀';
        } else {
            ch = input[readPosition];
        }

        position = readPosition;
        readPosition += 1;

    }

    Token nextToken() {

        skipWhitespace();

        Token token;

        switch (ch) {

            case '=':
                token = new Token(Token.Assign, ch);
                break;
            case ';':
                token = new Token(Token.SemiColon, ch);
                break;
            case '(':
                token = new Token(Token.LeftParen, ch);
                break;
            case ')':
                token = new Token(Token.RightParen, ch);
                break;
            case ',':
                token = new Token(Token.Comma, ch);
                break;
            case '+':
                token = new Token(Token.Plus, ch);
                break;
            case '{':
                token = new Token(Token.LeftBrace, ch);
                break;
            case '}':
                token = new Token(Token.RightBrace, ch);
                break;
            case '␀':
                token = new Token(Token.Eof, ch);
                break;
            default:
                if (isDigit(ch)) {
                    return new Token(Token.Int, readInteger());
                } else if (isAlpha(ch)) {
                    return new Token(Token.Ident, readIdentifier());
                }

                return new Token(Token.Illegal, ch);

        }

        readChar();
        return token;

    }

    bool isAlpha(String ch) {

        int c = ch.codeUnitAt(0);

        return c >= a && c <= z || c >= A && c <= Z || c == _;

    }

    bool isAlphaNumeric(String ch) {

        return isAlpha(ch) || isDigit(ch);

    }

    bool isAtEnd() {

        int c = ch.codeUnitAt(0);

        return c == nil;

    }

    bool isDigit(String ch) {

        int c = ch.codeUnitAt(0);

        return c >= zero && c <= nine;

    }

    bool isWhitespace(String ch) {

        int c = ch.codeUnitAt(0);

        return c == space || c == tab || c == newline || c == carriage;

    }

    String readIdentifier() {

        int start = position;

        while(isAlphaNumeric(ch) && !isAtEnd()) {
            readChar();
        }

        return input.substring(start, position);

    }

    String readInteger() {

        int start = position;

        while (isDigit(ch) && !isAtEnd()) {
            readChar();
        }

        return input.substring(start, position);

    }

    void skipWhitespace() {

        while (isWhitespace(ch) && !isAtEnd()) {
            readChar();
        }

    }

    static int code(String ch) {

        return ch.codeUnitAt(0);

    }

}