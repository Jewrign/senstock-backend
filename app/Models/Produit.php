<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Produit extends Model
{
    use HasFactory;

    protected $fillable = ['nom', 'categorie', 'description', 'stock', 'prix_unitaire', 'seuil_alerte', 'image'];

    public function mouvements()
    {
        return $this->hasMany(Mouvement::class);
    }
}
