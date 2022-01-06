"Annihilator": Tech 3 Energy Weapon
----
<table align="right">
    <thead>
        <tr>
            <th align="left" colspan="2">
                <img align="left" title="Annihilator unit icon" src="icons/units/ARMANNI_icon.png" />Annihilator<br />Tech 3 Energy Weapon
            </th>
        </tr>
    </thead>
    <tbody>
        <tr><td align="center" colspan="2">Note: Several units have stats defined at the<br />start of the game based on the stats of others.</td></tr>
        <tr>
            <td align="right"><strong>Source:</strong></td>
            <td><a href="SCTATest">SCTATest</a></td>
        </tr>
        <tr>
            <td align="right"><strong>Unit ID:</strong></td>
            <td><code>armanni</code></td>
        </tr>
        <tr>
            <td align="right"><strong>Faction:</strong></td>
            <td>ARM</td>
        </tr>
        <tr>
            <td align="right"><strong>Tech level:</strong></td>
            <td><img src="icons/T3.png" title="Tech 3" /> 3</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Health:</strong></td>
            <td><img src="icons/health.png" title="Health" /> 1410</td>
        </tr>
        <tr>
            <td align="right"><strong>Armour:</strong></td>
            <td><code>Structure</code></td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Energy cost:</strong></td>
            <td><img src="icons/energy.png" title="Energy" /> 25025</td>
        </tr>
        <tr>
            <td align="right"><strong>Mass cost:</strong></td>
            <td><img src="icons/mass.png" title="Mass" /> 3985</td>
        </tr>
        <tr>
            <td align="right"><strong>Build time:</strong></td>
            <td>75071 (<a href="#construction">Details</a>)</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Vision radius:</strong></td>
            <td>12</td>
        </tr>
        <tr>
            <td align="right"><strong>Water vision radius:</strong></td>
            <td>10</td>
        </tr>
        <tr>
            <td align="right"><strong>Radar radius:</strong></td>
            <td>30</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Weapons:</strong></td>
            <td>2 (<a href="#weapons">Details</a>)</td>
        </tr>
    </tbody>
</table>

"Annihilator" is an ARM structure unit included in *SCTATest*.
It is classified as a tech 3 energy weapon unit. It has no defined build description.<error:buildable unit with no build description>

<details>
<summary>Contents</summary>

1. – <a href="#construction">Construction</a>
2. – <a href="#order-capabilities">Order capabilities</a>
3. – <a href="#weapons">Weapons</a>
</details>

### Construction
Build times from hard coded builders on the Steam/retail version of the game:
* <img src="icons/time.png" title="Time" /> 12:30 ‒ <img src="icons/energy.png" title="Energy" /> 33/s ‒ <img src="icons/mass.png" title="Mass" /> 5/s — Built by <a href="ARMACA">Tech 2 Tech Level 2</a>
* <img src="icons/time.png" title="Time" /> 07:49 ‒ <img src="icons/energy.png" title="Energy" /> 53/s ‒ <img src="icons/mass.png" title="Mass" /> 8/s — Built by <a href="ARMACK">Tech 2 Tech Level 2</a>
* <img src="icons/time.png" title="Time" /> 06:15 ‒ <img src="icons/energy.png" title="Energy" /> 67/s ‒ <img src="icons/mass.png" title="Mass" /> 11/s — Built by <a href="ARMACV">Tech 2 Tech Level 2</a>
* <img src="icons/time.png" title="Time" /> 2:05:07 ‒ <img src="icons/energy.png" title="Energy" /> 3/s ‒ <img src="icons/mass.png" title="Mass" /> 1/s — Built by Tech 2 Engineer
* <img src="icons/time.png" title="Time" /> 31:16 ‒ <img src="icons/energy.png" title="Energy" /> 13/s ‒ <img src="icons/mass.png" title="Mass" /> 2/s — Built by Tech 2 Factory

### Order capabilities
The following orders can be issued to the unit:
<table>
<td><img float="left" src="icons/orders/attack.png" title="Attack" /></td>
<td><img float="left" src="icons/orders/stop.png" title="Stop" /></td>
<td><img float="left" src="icons/orders/stand-ground.png" title="Fire State" /></td>
</table>

### Weapons
<details>
<summary>ARM_TOTAL_ANNIHILATOR</summary>
<p>
    <table>
        <tr>
            <td align="right"><strong>Target type:</strong></td>
            <td><code>RULEWTT_Unit</code><error:Weapon hits high alt air and other stuff></td>
        </tr>
        <tr>
            <td align="right"><strong>DPS estimate:</strong></td>
            <td>500 <span title="Note: This only counts listed stats.">(<u>?</u>)</span></td>
        </tr>
        <tr>
            <td align="right"><strong>Damage:</strong></td>
            <td>2500 <span title="Note: This doesn't count additional scripted effects, such as splintering projectiles, and variable scripted damage.">(<u>?</u>)</span></td>
        </tr>
        <tr>
            <td align="right"><strong>Damage radius:</strong></td>
            <td>1</td>
        </tr>
        <tr>
            <td align="right"><strong>Damage type:</strong></td>
            <td><code>Normal</code></td>
        </tr>
        <tr>
            <td align="right"><strong>Max range:</strong></td>
            <td>55</td>
        </tr>
        <tr>
            <td align="right"><strong>Firing cycle:</strong></td>
            <td>Once every 5.0s <span title="Note: This doesn't count additional delays such as charging, reloading, and others.">(<u>?</u>)</span></td>
        </tr>
        <tr>
            <td align="right"><strong>Firing cost:</strong></td>
            <td><img src="icons/energy.png" title="Energy" /> 2000 (1000/s for 2.0s)</td>
        </tr>
        <tr>
            <td align="right"><strong>Flags:</strong></td>
            <td>Artillery shield blocks</td>
        </tr>
    </table>
</p>
</details>
<details>
<summary>DeathWeapon</summary>
<p>
    <table>
        <tr>
            <td align="right"><strong>Damage:</strong></td>
            <td>2000</td>
        </tr>
        <tr>
            <td align="right"><strong>Damage radius:</strong></td>
            <td>5</td>
        </tr>
        <tr>
            <td align="right"><strong>Damage type:</strong></td>
            <td><code>Normal</code></td>
        </tr>
        <tr>
            <td align="right"><strong>Flags:</strong></td>
            <td>Damage friendly</td>
        </tr>
    </table>
</p>
</details>


<table align=center>
<td>Categories : <a href="_categories.ARM">ARM</a> · <a href="_categories.TECH3">TECH3</a> · <a href="_categories.DIRECTFIRE">DIRECTFIRE</a> · <a href="_categories.STRUCTURE">STRUCTURE</a>
