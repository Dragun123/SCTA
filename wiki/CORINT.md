"Intimidator": Tech 3 Long Range Plasma Cannon
----
<table align="right">
    <thead>
        <tr>
            <th align="left" colspan="2">
                <img align="left" title="Intimidator unit icon" src="icons/units/CORINT_icon.png" />Intimidator<br />Tech 3 Long Range Plasma Cannon
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
            <td><code>corint</code></td>
        </tr>
        <tr>
            <td align="right"><strong>Faction:</strong></td>
            <td>CORE</td>
        </tr>
        <tr>
            <td align="right"><strong>Tech level:</strong></td>
            <td><img src="icons/T3.png" title="Tech 3" /> 3</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Health:</strong></td>
            <td><img src="icons/health.png" title="Health" /> 1900</td>
        </tr>
        <tr>
            <td align="right"><strong>Armour:</strong></td>
            <td><code>Structure</code></td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Energy cost:</strong></td>
            <td><img src="icons/energy.png" title="Energy" /> 62520</td>
        </tr>
        <tr>
            <td align="right"><strong>Mass cost:</strong></td>
            <td><img src="icons/mass.png" title="Mass" /> 4328</td>
        </tr>
        <tr>
            <td align="right"><strong>Build time:</strong></td>
            <td>93237 (<a href="#construction">Details</a>)</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Vision radius:</strong></td>
            <td>18</td>
        </tr>
        <tr>
            <td align="right"><strong>Water vision radius:</strong></td>
            <td>10</td>
        </tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr><td align="center" colspan="2"></td></tr>
        <tr>
            <td align="right"><strong>Weapons:</strong></td>
            <td>2 (<a href="#weapons">Details</a>)</td>
        </tr>
    </tbody>
</table>

"Intimidator" is a CORE structure unit included in *SCTATest*.
It is classified as a tech 3 long range plasma cannon unit. It has no defined build description.<error:buildable unit with no build description>

<details>
<summary>Contents</summary>

1. – <a href="#construction">Construction</a>
2. – <a href="#order-capabilities">Order capabilities</a>
3. – <a href="#weapons">Weapons</a>
</details>

### Construction
Build times from hard coded builders on the Steam/retail version of the game:
* <img src="icons/time.png" title="Time" /> 15:32 ‒ <img src="icons/energy.png" title="Energy" /> 67/s ‒ <img src="icons/mass.png" title="Mass" /> 5/s — Built by <a href="CORACA">Tech 2 Tech Level 2</a>
* <img src="icons/time.png" title="Time" /> 09:42 ‒ <img src="icons/energy.png" title="Energy" /> 107/s ‒ <img src="icons/mass.png" title="Mass" /> 7/s — Built by <a href="CORACK">Tech 2 Tech Level 2</a>
* <img src="icons/time.png" title="Time" /> 07:46 ‒ <img src="icons/energy.png" title="Energy" /> 134/s ‒ <img src="icons/mass.png" title="Mass" /> 9/s — Built by <a href="CORACV">Tech 2 Tech Level 2</a>
* <img src="icons/time.png" title="Time" /> 2:35:23 ‒ <img src="icons/energy.png" title="Energy" /> 7/s ‒ <img src="icons/mass.png" title="Mass" /> 0/s — Built by Tech 2 Engineer
* <img src="icons/time.png" title="Time" /> 38:50 ‒ <img src="icons/energy.png" title="Energy" /> 27/s ‒ <img src="icons/mass.png" title="Mass" /> 2/s — Built by Tech 2 Factory

### Order capabilities
The following orders can be issued to the unit:
<table>
<td><img float="left" src="icons/orders/attack.png" title="Attack" /></td>
<td><img float="left" src="icons/orders/stop.png" title="Stop" /></td>
<td><img float="left" src="icons/orders/stand-ground.png" title="Fire State" /></td>
</table>

### Weapons
<details>
<summary>CORE_INTIMIDATOR</summary>
<p>
    <table>
        <tr>
            <td align="right"><strong>Target type:</strong></td>
            <td><code>RULEWTT_Unit</code><br />(Anti-Surface)</td>
        </tr>
        <tr>
            <td align="right"><strong>DPS estimate:</strong></td>
            <td>300 <span title="Note: This only counts listed stats.">(<u>?</u>)</span></td>
        </tr>
        <tr>
            <td align="right"><strong>Damage:</strong></td>
            <td>1500 <span title="Note: This doesn't count additional scripted effects, such as splintering projectiles, and variable scripted damage.">(<u>?</u>)</span></td>
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
            <td align="right"><strong>Max range:</strong></td>
            <td>900</td>
        </tr>
        <tr>
            <td align="right"><strong>Firing cycle:</strong></td>
            <td>Once every 5.0s <span title="Note: This doesn't count additional delays such as charging, reloading, and others.">(<u>?</u>)</span></td>
        </tr>
        <tr>
            <td align="right"><strong>Firing cost:</strong></td>
            <td><img src="icons/energy.png" title="Energy" /> 1500 (1500/s for 1.0s)</td>
        </tr>
        <tr>
            <td align="right"><strong>Flags:</strong></td>
            <td>Artillery shield blocks<br />Damage friendly</td>
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
            <td>1000</td>
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
<td>Categories : <a href="_categories.CORE">CORE</a> · <a href="_categories.TECH3">TECH3</a> · <a href="_categories.ARTILLERY">ARTILLERY</a> · <a href="_categories.STRUCTURE">STRUCTURE</a>
