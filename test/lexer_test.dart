import 'package:test/test.dart';
import 'package:monkey/token/token.dart';
import 'package:monkey/lexer/lexer.dart';

Token t(String tokenType, String literal) {

    return new Token(tokenType, literal);

}

void testLexer(List<Token> expected, String input) {

    Lexer lexer = new Lexer(input);

    for (int i = 0; i < expected.length; i++) {

        Token expectedToken = expected[i];
        Token actualToken   = lexer.nextToken();

        expect(actualToken.tokenType, expectedToken.tokenType, reason: "tests[$i] - tokentype wrong.");
        expect(actualToken.literal, expectedToken.literal, reason: "tests[$i] - literal wrong.");

    }

}

void main() {

    test("test lexer with input '=+(){},;'", () {

        String input = "=+(){},;";

        List<Token> expected = [
            t(Token.Assign,     "="),
            t(Token.Plus,       "+"),
            t(Token.LeftParen,  "("),
            t(Token.RightParen, ")"),
            t(Token.LeftBrace,  "{"),
            t(Token.RightBrace, "}"),
            t(Token.Comma,      ","),
            t(Token.SemiColon,  ";"),
            t(Token.Eof,        "␀")
        ];

        testLexer(expected, input);

    });

    test("test lexer with input '+\\t\\n\\r +'", () {

        String input = "+\t\n\r +";

        List<Token> expected = [
            t(Token.Plus, "+"),
            t(Token.Plus, "+"),
            t(Token.Eof,  "␀")
        ];

        testLexer(expected, input);

    });

    test("test lexer with input '12345 23456'", () {

        String input = "12345 23456";

        List<Token> expected = [
            t(Token.Int, "12345"),
            t(Token.Int, "23456"),
            t(Token.Eof, "␀"),
        ];

        testLexer(expected, input);

    });

    test("test lexer with input 'add foo_bar y1 _x'", () {

        String input = "add foo_bar y1 _x";

        List<Token> expected = [
            t(Token.Ident, "add"),
            t(Token.Ident, "foo_bar"),
            t(Token.Ident, "y1"),
            t(Token.Ident, "_x"),
            t(Token.Eof, "␀"),
        ];

        testLexer(expected, input);

    });

}