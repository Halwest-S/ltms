<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Faq extends Model
{
    protected $fillable = [
        'question_en',
        'question_ku',
        'answer_en',
        'answer_ku',
        'sort_order',
    ];
}
