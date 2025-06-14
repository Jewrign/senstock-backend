<?php

namespace App\Http\Controllers;

use App\Models\Mouvement;
use App\Models\Produit;
use Illuminate\Http\Request;

class MouvementController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index($produit_id)
    {
        $produit = Produit::findOrFail($produit_id);
        return response()->json($produit->mouvements()->latest()->get());
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request, $produit_id)
    {
        $produit = Produit::findOrFail($produit_id);

        $validated = $request->validate([
            'type' => 'required|in:entrée,sortie',
            'quantite' => 'required|integer|min:1',
            'remarque' => 'nullable|string',
        ]);

        $mouvement = new Mouvement($validated);
        $mouvement->produit_id = $produit->id;
        $mouvement->save();

        if ($validated['type'] === 'entrée') {
            $produit->increment('stock', $validated['quantite']);
        } else {
            $produit->decrement('stock', $validated['quantite']);
        }

        return response()->json($mouvement, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Mouvement $mouvement)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Mouvement $mouvement)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Mouvement $mouvement)
    {
        //
    }
}
