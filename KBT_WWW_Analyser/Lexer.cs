using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace KBT_WWW_IS
{
    [System.Serializable]
    class Lexer_t
    {
        enum fstate { string_reading, int_reading };

        static void AddLexUseState(Queue<Tuple<symbol, int, int, int>> lex_seq, fstate State, string str, int ctr, int s, int e)
        {
            switch (State)
            {
                case fstate.string_reading:
                    lex_seq.Enqueue(Tuple.Create(new symbol("w", str), ctr, s, e));
                    break;
                case fstate.int_reading:
                    lex_seq.Enqueue(Tuple.Create(new symbol("n", str), ctr, s, e));
                    break;
                default:
                    throw new System.Exception("Bad end state in Lexer!");
            }
        }

        static public Queue<Tuple<symbol, int, int, int>> ProcessFile(string filename, rule_table rules)
        {
            if (!File.Exists(filename))
            {
                throw new System.Exception("File is not Exists! "+filename);
            }

            int ctr = 0;
            
            using (StreamReader ReportFile = new StreamReader(filename, Encoding.GetEncoding(1251)))
            {
                Queue<Tuple<symbol, int, int, int>> RetSeq = new Queue<Tuple<symbol, int, int, int>>();
                RetSeq.Enqueue(Tuple.Create(new symbol("w", Path.GetFileNameWithoutExtension(filename)), 0, 0, 0));

                Queue<Tuple<symbol, int, int, int>> temp_q = new Queue<Tuple<symbol, int, int, int>>();

                bool IgnoreSpaces = !(rules.T.Contains(new symbol("p")));

                while (!ReportFile.EndOfStream)
                {
                    string text = ReportFile.ReadLine();
                    ctr++;

                    // пустые строки/строки и комментарии пропускаем
                    if (text.Length == 0) continue;

                    if (rules.CommentLineStartSymbol != "" && text.Length >= rules.CommentLineStartSymbol.Length)
                        if (text.Substring(0, rules.CommentLineStartSymbol.Length) == rules.CommentLineStartSymbol)
                            continue;

                    string temp_str = ""; // буферизация последовательных строковых символоа
                            //space_buff = ""; // буферизация последовательных пробелов/табов

                    fstate State = fstate.int_reading; // предполагаем, что нам повезет и подряд идущие символы окажутся числом
                    bool temp_q_has_info = false; // в последовательности символов не встретилось символов, отличных от пробелов и табов
                    bool have_space = false;

                    temp_q.Clear();

                    int start = 0;
                    int end = 0;

                    foreach (char c in text)
                    {
                        end++;
                        if (Char.IsPunctuation(c) || Char.IsSymbol(c) || c == ' ' || c == '\t')
                        {
                            /* секция "встретился особый символ" */
                            if (temp_str != "")
                            {
                                AddLexUseState(temp_q, State, temp_str, ctr, start, end-1); // к этому моменту могла быть считана последовательность символов
                                start = end-1;
                            }

                            State = fstate.int_reading;
                            temp_str = "";

                            if (c != ' ' && c != '\t')
                            {
                                temp_q_has_info = true; // встретился отличный от пробела/таба символ

                                if (!IgnoreSpaces && have_space) temp_q.Enqueue(Tuple.Create(new symbol("p", " "), ctr, start, end));
                                have_space = false;

                                if (rules.T.Contains(new symbol(c)))
                                {
                                    temp_q.Enqueue(Tuple.Create(new symbol(c, c.ToString()), ctr, start, end));
                                    start = end;
                                }
                                else
                                {
                                    temp_q.Enqueue(Tuple.Create(new symbol("c", c.ToString()), ctr, start, end));
                                    start = end;
                                }
                                
                            }
                            else
                                if (temp_q_has_info)
                                    have_space = true;
                        }
                        else
                        {
                            if (Char.IsLetter(c))
                                State = fstate.string_reading; // предположение о том, что считываемая последовательность числовая - ошибочно

                            if (!IgnoreSpaces && have_space)
                            {
                                temp_q.Enqueue(Tuple.Create(new symbol("p", " "), ctr, start, end-1));
                                start = end;
                            }
                            have_space = false;

                            temp_q_has_info = true; // встретился отличный от пробела/таба символ

                            temp_str += c;
                        }

                    }

                    if (temp_q_has_info) // если в считанной последовательности оказалась ценная информация
                    {
                        while (temp_q.Count != 0)
                            RetSeq.Enqueue(temp_q.Dequeue()); // переписываем ее в генерируемый поток

                        if (temp_str != "")
                        {
                            AddLexUseState(RetSeq, State, temp_str, ctr, start, end);
                            start = end;
                        }

                        RetSeq.Enqueue(Tuple.Create(new symbol("nl", "\n"), ctr, start, end+1));
                    }
                }
                return RetSeq;
            }
        }
    }
}
